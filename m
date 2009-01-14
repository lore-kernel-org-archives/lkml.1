Return-Path: <linux-kernel-owner+w=401wt.eu-S1761911AbZANRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761911AbZANRqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZANRqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:46:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51156 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZANRqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:46:31 -0500
Message-ID: <496E2419.4020802@zytor.com>
Date: Wed, 14 Jan 2009 09:42:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: The policy on initramfs decompression failure
References: <496D17F9.8080605@zytor.com> <496D20FB.5010307@knaff.lu> <20090114054022.GA11153@elte.hu> <496D8E0D.5090401@knaff.lu> <20090114074852.GB16274@elte.hu>
In-Reply-To: <20090114074852.GB16274@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> By your argument the ton of warnings we emit in various situations are 
> wrong too and all should be panic()s. That argument is bogus.
> 

Thought about this whole thing some more, and it seems to me as follows:
what we really want, and need, is a "panic-level=X" option, where X will
naturally vary for differnet users.  I suspect there are many users
today who would prefer a panic (and reboot) on a KERN_CRIT message, even
at runtime.  For finer control, we need a message subsystem tag, but
that is something that would be highly desirable anyway.

As such, the initramfs decompression failure should be a KERN_CRIT or
KERN_ALERT message, and not a panic per se.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

