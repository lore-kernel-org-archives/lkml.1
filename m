Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZLAREJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZLAREJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZLAREI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:04:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61795 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbZLAREH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:04:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] "fair" rw spinlocks
Date: Tue, 1 Dec 2009 18:03:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20091123145409.GA29627@wotan.suse.de> <20091130171333.GG21639@wotan.suse.de> <alpine.LFD.2.00.0911300914240.2872@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911300914240.2872@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912011803.24664.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ab+QImrZPJan+7V/z0Hf0krMIi+efW9QI/Xc
 zeZUBj9a/KBolNn48cacAKL5tZXMFHv5mIxWj7sbNBQVKZBwYx
 nzR5mVkE5LW/f1UFn6WhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 November 2009, Linus Torvalds wrote:
> The best option really would be to try to make it all use RCU, rather than 
> paper over things. That really should improve performance.

Are there any writers at interrupt time? If not, another option might be
to first convert all the readers that can happen from interrupts to RCU,
which lets us get rid of the irq disable in the write path.

Step two could either be the conversion of all nested readers to RCU,
or your tasklist_read_lock(), which should then be safe. Doing both of
these lets us turn tasklist_lock into a plain spinlock, possibly followed
by converting remaining readers that show measurable lock contention.

	Arnd <><
