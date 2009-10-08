Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbZJHSsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbZJHSsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbZJHSsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:48:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZJHSsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:48:02 -0400
Date: Thu, 8 Oct 2009 20:47:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Alexander Strakh <strakh@ispras.ru>
Cc: Vladimir Shebordaev <vshebordaev@mail.ru>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>,
       Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [BUG] radio-gemtek-pci.c: double mutex_lock
In-Reply-To: <200910081852.50816.strakh@ispras.ru>
Message-ID: <alpine.LRH.2.00.0910082046370.12171@twin.jikos.cz>
References: <200910081852.50816.strakh@ispras.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Alexander Strakh wrote:

> 	KERNEL_VERSION: 2.6.31
> 	DESCRIBE:
> In driver ./drivers/media/radio/radio-gemtek-pci.c 
> mutex_lock is called first time in line 184, then in line 186 
> gemtek_pci_setfrequency is called.
> 
> 182 static void gemtek_pci_unmute(struct gemtek_pci *card)
> 183 {
> 184		mutex_lock(&card->lock);
> 185		if (card->mute) {
> 186         	gemtek_pci_setfrequency(card, card->current_frequency);
> 187			card->mute = false;
> 188		}
> 189		mutex_unlock(&card->lock);190 }
> 
> In gemtek_pci_setfrequency we call mutex_lock again in line 152
> 
> 144 static void gemtek_pci_setfrequency(struct gemtek_pci *card, unsigned long 
> frequency)
> 145 {
> 146         int i;
> 147         u32 value = frequency / 200 + 856;
> 148         u16 mask = 0x8000;
> 149         u8 last_byte;
> 150         u32 port = card->iobase;
> 151
> 152         mutex_lock(&card->lock);

Good catch. Adding Hans, who added the (incorrect) locking into 
gemtek_pci_unmute(), to CC.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

