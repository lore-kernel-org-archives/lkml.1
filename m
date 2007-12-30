Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbXL3JcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbXL3JcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 04:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXL3JcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 04:32:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbXL3JcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 04:32:12 -0500
Date: Sun, 30 Dec 2007 01:30:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: dpreed@reed.com, Islam Amer <pharon@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
In-Reply-To: <477711DC.5030800@keyaccess.nl>
Message-ID: <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
References: <477711DC.5030800@keyaccess.nl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 30 Dec 2007, Rene Herman wrote:
> 
> This fixes "hwclock" triggered boottime hangs for a few HP/Compaq laptops
> and might as such be applicable to 2.6.24 still.

It's not a regression as far as I can see (ie we've always done that port 
80 access for slow-down), and quite frankly, I think the code is horribly 
ugly.

Using a DMI quirk for something like this is just not maintainable. Are we 
going to live with doing new quirks forever? I'd rather just remove the 
slowdown entirely (obviously that is not for 2.6.24 either, though!), and 
drivers that then are shown to really need it could use their *own* ports.

		Linus
