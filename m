Return-Path: <linux-kernel-owner+w=401wt.eu-S1946405AbXBCJT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946405AbXBCJT5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 04:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946413AbXBCJT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 04:19:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:22307 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946405AbXBCJT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 04:19:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JdE64p0xj/1nADfZhHrOQ9vhYFzlLzYY+4HKcaRJkfMfPMbFDzPnGv532RbwjnuPBphMjo3GYxUIHMEkjlfLmkKU2jFURahfYl6QmV0OenIJQ9xRPcdvxLyXKaVNosd0Zd4xgpqfCwmx9y0BMyYKGgmtWaQDIZj/QZ0Wbn4WMj4=
Subject: Re: 2.6.20-rc7: known regressions
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Adrian Bunk <bunk@stusta.de>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>, Stephen Hemminger <shemminger@osdl.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
In-Reply-To: <20070202175504.a3bab5ac.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	 <20070202054916.GA3754@stusta.de>
	 <20070202175504.a3bab5ac.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Sat, 03 Feb 2007 10:19:51 +0100
Message-Id: <1170494391.31373.25.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 02 février 2007 à 17:55 -0800, Andrew Morton a écrit :
> - I have efi-x86-pass-firmware-call-parameters-on-the-stack.patch, but
>   I'm not sure it's right and unless something really rapid happens, we'll
>   ship with that bug unfixed.

Things I can say:
 - Works for me :-)
 - When you look at the code, it's obvious that switching to -mregparm=3
changed the way we call into EFI runtime services. If you consider that
that old code was correct, then the patch is needed to keep the good
calling convention.
 - It touches only arch/i386/kernel/efi.c which is compiled only with
CONFIG_EFI && X86
 - It changes code that is called only when booted in EFI mode.

Last 2 points mean the user base is pretty limited, which can be taken
both as an argument to push it for the release or not to. I'd obviously
prefer that someone knowledgeable about EFI looks at it and ACKs before
it goes in.

Fred.

