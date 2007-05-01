Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbXEAEuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbXEAEuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXEAEuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:50:39 -0400
Received: from ozlabs.org ([203.10.76.45]:42466 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbXEAEuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:50:37 -0400
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
	relocatable bzImage
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <4636BB6B.9070300@zytor.com>
References: <20070428758.455116000@suse.de>
	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
	 <1177902195.30071.203.camel@localhost.localdomain>
	 <463572B7.90202@zytor.com>
	 <1177909434.30071.216.camel@localhost.localdomain>
	 <m1ejm16flv.fsf@ebiederm.dsl.xmission.com>
	 <1177990722.28659.39.camel@localhost.localdomain>
	 <4636B7DE.5050005@zytor.com>  <4636BB6B.9070300@zytor.com>
Content-Type: text/plain
Date: Tue, 01 May 2007 14:50:14 +1000
Message-Id: <1177995014.28659.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 21:00 -0700, H. Peter Anvin wrote:
> H. Peter Anvin wrote:
> > Rusty Russell wrote:
> >> It'd be nicer if there were a "struct boot_params" declaration, but we
> >> can't have everything.
> > 
> > It's in my patchset-under-development.
> > 
> > (Preview snapshot:
> > http://userweb.kernel.org/~hpa/setup-snapshot-2007.04.30.patch)
> 
> Just pushed out a git tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=summary

Any chance of splitting off a "struct boot_params" header (includable by
non-kernel code) for inclusion immediately?  The rest can wait until
2.6.23, but it'd be sweet to get this in place sooner.

BTW, wrt. a new "platform type" field, should it go something like this?

-0235/3	N/A	pad2		Unused
+0235/1	2.07+	platform_type	Runtime platform (see below)
+0236/2	N/A	pad2		Unused
...
+  platform_type:
+	For kernels which can boot on multiple platforms.  Currently
+	0 == native (normal), 1 == lguest (paravirtualized).

Thanks,
Rusty.


