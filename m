Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbZBESYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbZBESYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbZBESX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:23:59 -0500
Received: from gw.goop.org ([64.81.55.164]:54860 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbZBESX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:23:59 -0500
Message-ID: <498B2EBC.60700@goop.org>
Date: Thu, 05 Feb 2009 10:23:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: pud_bad vs pud_bad
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at unifying the 32 and 64-bit versions of pud_bad.

32-bits defines it as:

static inline int pud_bad(pud_t pud)
{
	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
}

and 64 as:

static inline int pud_bad(pud_t pud)
{
	return (pud_val(pud) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
}


I'm inclined to go with the 64-bit version, but I'm wondering if there's 
something subtle I'm missing here.

Thoughts?

    J
