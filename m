Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZCNQHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZCNQHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZCNQHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:07:01 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:43362 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZCNQHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:07:01 -0400
Message-ID: <49BBD619.6050809@davidnewall.com>
Date: Sun, 15 Mar 2009 02:36:49 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Screwy arch/x86/include/asm/string_32.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a lot of weirdness in __constant_memcpy in
arch/x86/include/asm/string_32.h (2.6.29-rc7).

   1. The first switch is missing a case for n equal 7.
   2. When n < 20, the four tests (n > 16, n > 12, n > 8 & n > 4)
      execute identical statements; always 'asm volatile("movsl" :
      "=&D"(edi), "=&S"(esi) : "0"(edi), "1"(esi) : "memory")'.


I think it copies less than 4 bytes for values of n between 9 and 19.
