Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZHMSbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZHMSbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 14:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbZHMSbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 14:31:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57556 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbZHMSbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 14:31:31 -0400
Date: Thu, 13 Aug 2009 13:31:24 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov, davem@davemloft.net, shemminger@linux-foundation.org,
       kees@ubuntu.com, morgan@kernel.org, casey@schaufler-ca.com,
       dwalsh@redhat.com
Subject: Re: [PATCH 2/3] security: introducing security_request_module
Message-ID: <20090813183124.GA8171@us.ibm.com>
References: <20090813134451.29186.41664.stgit@paris.rdu.redhat.com> <20090813134457.29186.7182.stgit@paris.rdu.redhat.com> <20090813140306.GC30731@us.ibm.com> <1250177334.2182.88.camel@dhcp231-106.rdu.redhat.com> <20090813175405.GA6824@us.ibm.com> <1250187550.2115.19.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250187550.2115.19.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> On Thu, 2009-08-13 at 12:54 -0500, Serge E. Hallyn wrote:
> > Quoting Eric Paris (eparis@redhat.com):
> > > On Thu, 2009-08-13 at 09:03 -0500, Serge E. Hallyn wrote:
> > > > Quoting Eric Paris (eparis@redhat.com):
> > > > > Calling request_module() will trigger a userspace upcall which will load a
> > > > > new module into the kernel.  This can be a dangerous event if the process
> > > > > able to trigger request_module() is able to control either the modprobe
> > > > > binary or the module binary.  This patch adds a new security hook to
> > > > > request_module() which can be used by an LSM to control a processes ability
> > > > > to call request_module().
> > > > 
> > > > Is there a specific case in which you'd want to deny this ability
> > > > from a real task?
> > > 
> > > qemu and any network facing daemon are all programs I don't want to be
> > > able to even ask the kernel to load a module.  Clearly you are right,
> > 
> > ...  What if the network facing daemon might want to use a kernel crypto
> > module?  What if qemu needs the tun module loaded?
> 
> Loading code into the kernel is a dangerous operation.  We should find
> the places where high risk processes are doing this and either choose to
> accept the security risk or make sure they are loaded before the
> dangerous code is run, aka libvirt knows if the guest needs the tun
> device and it should be allowed to trigger it's loading.  It's shouldn't
> be the guest doing the triggering.

Well, I continue to be dubious, but the hook does no harm so in case
it sounded otherwise, I don't object.

Mind you the right thing to do would be i.e. in the qemu case to have
a more privileged helper load the needed modules and then fire off a
qemu unable to cause module loads.  If userspace is willing to jump
through that rather minimal hoop then this could be useful I suppose.

thanks,
-serge
