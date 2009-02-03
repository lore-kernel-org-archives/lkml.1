Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZBCN1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZBCN1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbZBCN1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:27:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbZBCN1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:27:03 -0500
Date: Tue, 3 Feb 2009 13:26:08 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: debian-devel@lists.debian.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: cgroup mount point
Message-ID: <20090203132608.GA15613@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com> <20090203102416.GA8886@redhat.com> <20090203123028.GA3788@vespa.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203123028.GA3788@vespa.holoscopio.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 10:30:28AM -0200, Thadeu Lima de Souza Cascardo wrote:
> Sorry. I didn't mean to imply that libvirt or Fedora did anything in
> respect to the mountpoint themselves. But that they are supporting or
> planning to support cgroups. And I think that one time we will need to
> sort the problem of the mountpoint, either let the applications mount it
> (in this case, libvirt) or the system do it (Fedora install, Debian
> initscripts, et al).
>
> I have some experience with lxc tools from http://lxc.sf.net/ and these
> tools also look up the mountpoint at /proc/mounts. So it is up to the
> system or the user to mount it.

That's good. We settled on letting mount points be OS / admin defined
in libvirt, because we felt libvirt shouldn't try to impose a mount
policy on a resource that will have many users & we are able to work
with whatever mount hierarchy the admin / OS decided to setup.

> > Putting new mount points in / is not really acceptable, so that rules
> > out the first two. /opt is just totally wrong, since that is intended
> > for add on software packages. /dev/ feels a little odd, since it is
> > not really device nodes, but perhaps that doesn't matter. So my pref
> > would be something in /dev/cgroups or /sys/cgroups
> 
> My suggestions were /proc/cgroup, /sys/cgroup, /cgroup or /dev/cgroup. I
> sent the problems with the former two, and the rationale for the latter
> two in a previous message.
> 
> I agree that /opt/ is not the place for it (and that's the one I called
> 'funny'). I've head some people telling that /dev/ is for devices, but I
> can't see a problem (/dev/log is a socket and it is there, the FHS
> refers to special files).
> 
> /proc/ and /sys/ are two good options if the kernel does not put anything
> else there. /proc/cgroups already exist, for example.
> 
> Could you please give your rationale why / is not really acceptable?
 
Just a general preference is to not continually add more ad-hoc top 
level directories to /, when there are other places in the filesystem
hierarchy that are available, such as /sys or /proc. 

> > I also think 'cgroups' is a better name than 'containers', since 
> > 'containers' is refering to just one specific use case.
> 
> Agreed on this one, although I still prefer the singular (it is also the
> name of the filesystem type).

Either singular / plural sounds fine to me

Regards,
Daniel
-- 
|: Red Hat, Engineering, London   -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org  -o-  http://virt-manager.org  -o-  http://ovirt.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-  F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
