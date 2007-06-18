Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbXFRIdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbXFRIdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbXFRIdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:33:41 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:49640 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXFRIdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:33:40 -0400
Message-ID: <46764352.4000805@alcatel-lucent.com>
Date: Mon, 18 Jun 2007 16:33:22 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "Chen, Jinmin (Jinmin)" <jinminc@alcatel-lucent.com>
Subject: Questions on one PowerPC assembly instruction from hash_page
References: <20070614142430.GA2388@darkstar.te-china.tietoenator.com> <20070615132657.GW6149@kernel.dk> <20070618125811.GA1692@darkstar.te-china.tietoenator.com> <20070618062722.GP6149@kernel.dk> <a8e1da0706172341j3ee621efs8b2809b4fd094004@mail.gmail.com> <20070618064350.GQ6149@kernel.dk> <a8e1da0706180003u35003bb6j706efc25c2b287db@mail.gmail.com> <20070618070519.GR6149@kernel.dk>
In-Reply-To: <20070618070519.GR6149@kernel.dk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2007 08:33:08.0351 (UTC) FILETIME=[4C5F88F0:01C7B183]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Guys,

I can't understand the following instructions from 
arch/ppc/mm/hashtable.S::hash_page. If I got the right design, the 
following instruction is to get the PMD (Page Middle Descritor) because 
Linux for 32-bits PowerPC cut page table into 3 domains: root, PMD, PTE. 
The top bits (22 to 31 bit) is the index for PMD, and the next 10 bits 
(12 to 21 bit) is the index for PTE in the associative PMD. The 
remaining 12 bits (0 to 11 bit) indicated the page size (4KB). However, 
the following instruction polled [8-17] bits instead of [22-31] bits as 
expected. Anybody could give me answer?

r4 is the address that caused the DSI
r5 is the address of swapper_pg_dir if we are under kernel mode.

rlwimi r5,r4,12,20,29 /* insert top 10 bits of address */

Thanks,
Gavin


