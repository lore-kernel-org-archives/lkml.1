Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYIYBUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYIYBUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 21:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYIYBUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 21:20:45 -0400
Received: from sous-sol.org ([216.99.217.87]:46895 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752077AbYIYBUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 21:20:44 -0400
Date: Wed, 24 Sep 2008 18:19:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/2] file capabilities: remove
	CONFIG_SECURITY_FILE_CAPABILITIES
Message-ID: <20080925011945.GA23181@sequoia.sous-sol.org>
References: <20080924020432.GA25997@us.ibm.com> <20080924020526.GA26058@us.ibm.com> <20080924234857.GA22375@sequoia.sous-sol.org> <20080925010233.GB7324@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925010233.GB7324@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serue@us.ibm.com) wrote:
> Quoting Chris Wright (chrisw@sous-sol.org):
> > * Serge E. Hallyn (serue@us.ibm.com) wrote:
> > > Remove the option to compile the kernel without file capabilities.  Not
> > > compiling file capabilities actually makes the kernel less safe, as it
> > > includes the possibility for a task changing another task's capabilities.
> > > 
> > > Some are concerned that userspace tools (and user education) are not
> > > up to the task of properly configuring file capabilities on a system.
> > > For those cases, there is now the ability to boot with the no_file_caps
> > > boot option.  This will prevent file capabilities from being used in
> > > the capabilities recalculation at exec, but will not change the rest
> > > of the kernel behavior which used to be switchable using the
> > > CONFIG_SECURITY_FILE_CAPABILITIES option.
> > 
> > (note: defconfig has CONFIG_SECURITY_FILE_CAPABILITIES=y)
> >    text    data     bss     dec     hex filename
> > 6805157 1018344  671900 8495401  81a129 obj64-defconfig/vmlinux
> > 6805151 1018368  671900 8495419  81a13b obj64-defconfig-patch1/vmlinux
> > 6805151 1018368  671900 8495419  81a13b obj64-defconfig-patch2/vmlinux
> > 6804605 1018344  671900 8494849  819f01 obj64-nofcap/vmlinux
> > 6804604 1018344  671900 8494848  819f00 obj64-nofcap-patch1/vmlinux
> > 6805150 1018368  671900 8495418  81a13a obj64-nofcap-patch2/vmlinux
> 
> (what are you using to get these numbers?)

Just building w/ O=obj64... and then using "size obj64-*/vmlinux"

> > The last 2 show the real diff now, add 570 bytes by effectively forcing
> > CONFIG_SECURITY_FILE_CAPABILITIES on.
> 
> That surprises me - I thought a reasonable amount of code was cut as
> well.  Sounds like it may be worth it to refactor some of the code.

Be nice to cut it down if you can.

> > What is being done to enable userspace in distros to make those 570
> > bytes generally useful?
> 
> Fedora 9 and ubuntu intrepid already have full capabilities support and
> modern libcap.  Sles is set to ship with a modern libcap, and according
> to what Andreas is saying, if we can provide them with the no_file_caps
> boot option then suse is willing to have a kernel with capabilities
> turned on.  I think gentoo still comes with libcap-1.  Need to look into
> changing that.
> 
> I suppose the next baby-step will be to do get rid of setuid on little
> things like ping.  Actually using inheritable caps for pseudo-admin
> 'roles' may be a bit farther off, and a particularly interesting problem
> will be to take huge pieces of cross-os software like ssh which make
> assumptions about setuid behavior, and find ways to make them work
> correctly with capabilities, with capabilities in
> SECURE_NOROOT|SECURE_NOSETUIDFIXUP, and with non-linux oses.

The baby step including simple things like setuid ping was the step I was
thinking of.  That w/ embedded and bloatwatch in mind is why I asked.

thanks,
-chris
