Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXKDXSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXKDXSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXKDXS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:18:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168AbXKDXS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:18:27 -0500
Date: Sun, 4 Nov 2007 15:17:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486DX4
In-Reply-To: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org>
Message-ID: <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org>
References: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Nov 2007, H. Peter Anvin wrote:
>     
>     Apparently, the 486DX4 does not correctly serialize a mov to %cr0, so
>     we really do need the far jump immediately afterwards.

Hmm. I'm not sure I agree with the commit message.

This is documented behaviour on i386 and i486: instruction decoding is 
decoupled from execution, so things that change processor mode have to do 
a jump to make sure that %cr0 changes take effect.

I'm not entirely sure that it needs to be a long-jump, btw. I think any
regular branch is sufficient. You obviously *do* need to make the long 
jump later (to reload %cs in protected mode), but I'm not sure it's needed 
in that place. I forget the exact rules (but they definitely were 
documented).

		Linus
