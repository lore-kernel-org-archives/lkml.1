Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbYIQH3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbYIQH3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 03:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYIQH25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 03:28:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:28202 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYIQH24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 03:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NqvXNCk4doz1uhlWXKn0QqNP77NXPwF4BjGOrAdiYFL+Y7c6DB/I4ULkJnRLJoQGEB
         R/9ezo70CLdqAFXQ5oKQvBocU2gibLraesOZcUFtdciiQsqYqwGKRh0kcNJqZlE6dyM2
         yNaSzS3wvtzA+35vAz0283KHp0a8wf5k6GAP8=
Date: Wed, 17 Sep 2008 11:30:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v5
Message-ID: <20080917073058.GA3770@x200.localdomain>
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 12:10:09AM -0700, Yinghai Lu wrote:
>     KERN_PCI
>     KERN_ACPI
> v4: fix some checkpatch error and warning
> v5: add default with DEFINE_LOGLEVE_SETUP_DEF
>     KERN_APIC
> 
> usage:
> 	in .h to have
> 		#define KERN_PCI "<pci>"
> 	in .c to have
> 		DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
> 	then could use
> 		printk(KERN_DEBUG KERN_PCI fmt, ...);
> 	and command line
> 		loglevel=3,pci:8
> 
> you can add different printk to different files of one subsys if you like
> not just one susbsys one tag, and don't need to update kernel.h to add more tags

I think all of this is overdesigned and stupid.

People expecting that loglevels are exactly right so they can calm messages
are like security-savvy people who expect all security relevant bugfixes carry
CVE tag.

grep says there are 50757 printk calls, only 32129 of them carry KERN_ tag.

Oh, and new and improved logs:

	[    0.340326] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
	[    0.340326] pci 0000:00:01.0: PME# disabled
	[    0.340326] <pci>PCI: 0000:00:1a.0 reg 20 io port: [dc00, dc1f]
	[    0.340413] <pci>PCI: 0000:00:1a.1 reg 20 io port: [e000, e01f]
	[    0.340549] <pci>PCI: 0000:00:1a.7 reg 10 32bit mmio: [febffc00, febfffff]
		       ^^^^^^^^^

How this can be an improvement for those who boot with ignore_loglevel,
I don't know.
