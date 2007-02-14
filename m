Return-Path: <linux-kernel-owner+w=401wt.eu-S932644AbXBNVeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbXBNVeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932648AbXBNVeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:34:04 -0500
Received: from mail.gurulabs.com ([67.137.148.7]:43410 "EHLO mail.gurulabs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644AbXBNVeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:34:02 -0500
Subject: Re: Linus' laptop and Num lock status
From: Dax Kelson <dax@gurulabs.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702141130340.20368@woody.linux-foundation.org>
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>
	 <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
	 <20070214202144.1ddb930f.khali@linux-fr.org>
	 <Pine.LNX.4.64.0702141130340.20368@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 14:34:00 -0700
Message-Id: <1171488840.3706.78.camel@mentorng.gurulabs.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 11:32 -0800, Linus Torvalds wrote:
> 
> On Wed, 14 Feb 2007, Jean Delvare wrote:
> > 
> > On x86, the BIOS led state can be read from byte 0x97 the BIOS RAM. The
> > BIOS RAM is mapped at 0x400 so all we need to do is to one byte from
> > RAM (offset 0x497). This is how Suse's hwinfo does.
> 
> Heh. Shows just how much I ever used DOS and BIOS.
> 
> > But maybe the first question to ask is: why is the BIOS setting lost in
> > the first place? Why is the kernel resetting the led state?
> 
> Ehh. Silly question. "Those flags, they do nothing."
> 
> The kernel needs to know what they are in order to react correctly to 
> them. And since you can't read them from hardware, the only way to know 
> what they are (if you don't know about BIOS magic areas) is to SET THEM.
> 
> Which is what the kernel has traditionally always done.

Going forward can the kernel peek at 0x497 and follow the BIOS setting?

I checked, and looking at offset 0x497 seems to work fine on a couple of
systems with USB keyboards.

People have long grumbled and complained about the current kernel
behavior (1).

Dax Kelson

(1)
http://lkml.org/lkml/1999/2/27/6
http://www.google.com/search?q=linux+num+lock
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=115909

