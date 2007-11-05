Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbXKESdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbXKESdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbXKESdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:33:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39832 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbXKESdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:33:04 -0500
Message-ID: <472F61C8.4040300@zytor.com>
Date: Mon, 05 Nov 2007 10:32:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org> <alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org> <472F5941.2060507@zytor.com> <alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Final comment: shouldn't we set up %esp to be correct for the new %ss too?
> 

Well, the 32-bit code needs to set up its own stack, and only it knows 
where it wants its stack; we don't guarantee that the stack is valid 
when we enter the 32-bit code and we're entering with both INT and NMI 
disabled (requiring a stack would probably break all existing users of 
the 32-bit entrypoint.)

However, that being said, doing so is trivial, and it might help some 
debugging hack; anything that makes debugging easier is a Good Thing[TM].

	-hpa
