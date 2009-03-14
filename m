Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZCNXsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZCNXsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 19:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZCNXsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 19:48:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54200 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZCNXsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 19:48:11 -0400
Message-ID: <49BC413B.5020104@zytor.com>
Date: Sat, 14 Mar 2009 16:43:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>, Yinghai Lu <yinghai@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Latest brk patchset
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I was reviewing the latest brk patchset, and I have a question:

Why is the brk merged into the .bss, instead of being left in its own
(nobits) segment:

  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
	__init_end = .;
	__bss_start = .;		/* BSS */
	*(.bss.page_aligned)
	*(.bss)
	. = ALIGN(4);
	__bss_stop = .;

	. = ALIGN(PAGE_SIZE);
	__brk_base = . ;
	. += 64 * 1024 ;	/* 64k slop space */
	*(.brk_reservation)	/* areas brk users have reserved */
	__brk_limit = . ;

  	_end = . ;
  }

It really doesn't make much sense to me, and is more than a bit
confusing given the symbols.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

