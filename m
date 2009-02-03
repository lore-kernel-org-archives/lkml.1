Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbZBCK0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbZBCK0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 05:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZBCKZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 05:25:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZBCKZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 05:25:58 -0500
Date: Tue, 3 Feb 2009 10:24:16 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: debian-devel@lists.debian.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: cgroup mount point
Message-ID: <20090203102416.GA8886@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202214153.GV3643@vespa.holoscopio.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 07:41:53PM -0200, Thadeu Lima de Souza Cascardo wrote:
> On Mon, Feb 02, 2009 at 09:52:46PM +0100, Mike Hommey wrote:
> > On Mon, Feb 02, 2009 at 09:26:11PM +0100, Julien Cristau wrote:
> > > On Mon, 2009-02-02 at 18:00 -0200, Thadeu Lima de Souza Cascardo wrote:
> > > > Hello,
> > > > 
> > > > Some software I intend to package work with the new cgroup feature in
> > > > Linux. I would like to open a discussion about what would be the better
> > > > place to mount it and how/when to mount it.
> > > 
> > > What do other distros use?
> > 
> > Even better: what do the kernel folks want to do?
> > 
> > Mike
> 
> From what I've seen, most of them are in the same phases as Debian, or,
> perhaps, behind. Fedora seems to plan that for Fedora 11, and they have
> some support in libvirt.

libvirt is not going to impose any policy for mount points, nor mount
anything itself. When we use cgroups, libvirt just looks up the mount
table to find out where the admin or distro has put the mount points
for each cgroups controller.

I've also not done anything in default Fedora install to automatically
setup cgroups, since doing that hits the hard-to-answer question of
whether to mount all controllers in one, or a separate mount per
controller, or a hybrid.

> So, we have some more options now: /cgroups, /containers, /dev/cpuset,
> /dev/cpuctl, /opt/cgroup, /opt/cpuset.

Putting new mount points in / is not really acceptable, so that rules
out the first two. /opt is just totally wrong, since that is intended
for add on software packages. /dev/ feels a little odd, since it is
not really device nodes, but perhaps that doesn't matter. So my pref
would be something in /dev/cgroups or /sys/cgroups

I also think 'cgroups' is a better name than 'containers', since 
'containers' is refering to just one specific use case.

Regards,
Daniel
-- 
|: Red Hat, Engineering, London   -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org  -o-  http://virt-manager.org  -o-  http://ovirt.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-  F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
