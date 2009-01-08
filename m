Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbZAHTX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbZAHTX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760728AbZAHTXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:23:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:57685 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbZAHTXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:23:46 -0500
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Jan 2009 20:23:29 +0100
Message-Id: <1231442609.27687.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 11:13 -0800, Linus Torvalds wrote:
> 
> Well, at least we do unless you enable that broken paravirt support. I'm 
> not at all clear on why CONFIG_PARAVIRT wants to use inferior locks, but I 
> don't much care.

Because the virtual cpu that has the ticket might not get scheduled for
a while, even though another vcpu with a spinner is scheduled.

The whole (para)virt is a nightmare in that respect.
