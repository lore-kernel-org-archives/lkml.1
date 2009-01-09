Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZAIE7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZAIE7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 23:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZAIE7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 23:59:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35955
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751734AbZAIE7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 23:59:32 -0500
Date: Thu, 08 Jan 2009 20:59:33 -0800 (PST)
Message-Id: <20090108.205933.96892305.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: hpa@zytor.com, mingo@elte.hu, chris.mason@oracle.com, peterz@infradead.org,
       rostedt@goodmis.org, paulmck@linux.vnet.ibm.com, ghaskins@novell.com,
       matthew@wil.cx, andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
       pmorreale@novell.com, SDietrich@novell.com
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>
References: <20090108183306.GA22916@elte.hu>
	<496648C7.5050700@zytor.com>
	<alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Jan 2009 19:46:30 -0800 (PST)

> First off, gcc _does_ have a perfectly fine notion of how heavy-weight an 
> "asm" statement is: just count it as a single instruction (and count the 
> argument setup cost that gcc _can_ estimate).

Actually, at least at one point, it counted the number of newline
characters in the assembly string to estimate how many instructions
are contained inside.

It actually needs to know exaclty how many instructions are in there,
to emit proper far branches and stuff like that, for some cpus.

Since they never added an (optional) way to actually tell the compiler
this critical piece of information, so I guess the newline hack is the
best they could come up with.
