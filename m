Return-Path: <linux-kernel-owner+w=401wt.eu-S1751665AbXBEQdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbXBEQdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbXBEQdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:33:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbXBEQdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:33:20 -0500
Date: Mon, 5 Feb 2007 08:32:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170682488.29759.795.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702050829360.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> 
 <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, David Woodhouse wrote:
> 
> Secondly, please don't _ever_ use 'select'.

No, David.

I don't know why you keep repeating this mantra, when it's WRONG.

Using "select" is a lot more sane and intelligent than assuming that users 
know what dependencies they want.

The Kconfig files should ask about *end-user* visible features. They 
should say "do you want to support X".

If "X" then needs Y, Z and something else to actually compile, then that 
Kconfig file should DAMN WELL use "select". Stop claiming anything else!

The user shouldn't know that they should say that they need some library Y 
in order to even see the question for "X". It's not a sane thing to ask 
them to know and care about. They care about the devices or capabilities 
they want to support, not about the fact that a USB storage device needs 
the SCSI core layer, for example.

So stop saying "don't use select".

		Linus
