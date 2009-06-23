Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbZFWOoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbZFWOoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZFWOob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:44:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37581 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZFWOob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:44:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090620043303.GA19855@localhost>
References: <20090620043303.GA19855@localhost> <32411.1245336412@redhat.com> <20090517022327.280096109@intel.com> <2015.1245341938@redhat.com> <20090618095729.d2f27896.akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] make mapped executable pages the first class citizen
Date: Tue, 23 Jun 2009 15:43:57 +0100
Message-ID: <7561.1245768237@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> wrote:

> David, could you try running this when it occurred again?
> 
>         make Documentation/vm/page-types
>         Documentation/vm/page-types --raw  # run as root

Okay.  I managed to catch it between the first and second OOMs, and ran the
command you asked for.

David
---
             flags	page-count       MB  symbolic-flags			long-symbolic-flags
0x0000000000000000	    142261      555  ________________________________	
0x0000000100000000	      5588       21  ____________________r___________	reserved
0x0000004000000000	        17        0  __________________________h_____	arch
0x0000000800000004	         4        0  __R____________________P________	referenced,private
0x0000000800000024	      2073        8  __R__l_________________P________	referenced,lru,private
0x0000000400000028	     69911      273  ___U_l________________d_________	uptodate,lru,mappedtodisk
0x0001000400000028	        16        0  ___U_l________________d_____I___	uptodate,lru,mappedtodisk,readahead
0x0000000800000028	        25        0  ___U_l_________________P________	uptodate,lru,private
0x0000000000000028	        11        0  ___U_l__________________________	uptodate,lru
0x000000040000002c	      3045       11  __RU_l________________d_________	referenced,uptodate,lru,mappedtodisk
0x000000080000002c	         4        0  __RU_l_________________P________	referenced,uptodate,lru,private
0x0000000800000034	         9        0  __R_Dl_________________P________	referenced,dirty,lru,private
0x0000000800000038	         1        0  ___UDl_________________P________	uptodate,dirty,lru,private
0x0000000000004038	        13        0  ___UDl________b_________________	uptodate,dirty,lru,swapbacked
0x000000080000003c	         1        0  __RUDl_________________P________	referenced,uptodate,dirty,lru,private
0x0000000800000060	       183        0  _____lA________________P________	lru,active,private
0x0000000800000064	       982        3  __R__lA________________P________	referenced,lru,active,private
0x0000000400000068	       473        1  ___U_lA_______________d_________	uptodate,lru,active,mappedtodisk
0x0000000c00000068	         1        0  ___U_lA_______________dP________	uptodate,lru,active,mappedtodisk,private
0x000000040000006c	       392        1  __RU_lA_______________d_________	referenced,uptodate,lru,active,mappedtodisk
0x0000000c0000006c	         1        0  __RU_lA_______________dP________	referenced,uptodate,lru,active,mappedtodisk,private
0x0000000800000070	         1        0  ____DlA________________P________	dirty,lru,active,private
0x0000000800000074	        20        0  __R_DlA________________P________	referenced,dirty,lru,active,private
0x0000000c00000078	         2        0  ___UDlA_______________dP________	uptodate,dirty,lru,active,mappedtodisk,private
0x0000000000004078	         1        0  ___UDlA_______b_________________	uptodate,dirty,lru,active,swapbacked
0x000000080000007c	         1        0  __RUDlA________________P________	referenced,uptodate,dirty,lru,active,private
0x0000000000000080	     18684       72  _______S________________________	slab
0x0000000000000400	      6797       26  __________B_____________________	buddy
0x0000000000000804	         1        0  __R________M____________________	referenced,mmap
0x0000000400000828	       195        0  ___U_l_____M__________d_________	uptodate,lru,mmap,mappedtodisk
0x000000040000082c	        35        0  __RU_l_____M__________d_________	referenced,uptodate,lru,mmap,mappedtodisk
0x0000000000004838	         2        0  ___UDl_____M__b_________________	uptodate,dirty,lru,mmap,swapbacked
0x0000000400000868	        11        0  ___U_lA____M__________d_________	uptodate,lru,active,mmap,mappedtodisk
0x000000040000086c	       274        1  __RU_lA____M__________d_________	referenced,uptodate,lru,active,mmap,mappedtodisk
0x0000000800000878	         1        0  ___UDlA____M___________P________	uptodate,dirty,lru,active,mmap,private
0x000000080000087c	         2        0  __RUDlA____M___________P________	referenced,uptodate,dirty,lru,active,mmap,private
0x0000000000005008	         8        0  ___U________a_b_________________	uptodate,anonymous,swapbacked
0x0000000000005808	         6        0  ___U_______Ma_b_________________	uptodate,mmap,anonymous,swapbacked
0x0000000000005828	      4325       16  ___U_l_____Ma_b_________________	uptodate,lru,mmap,anonymous,swapbacked
0x0000000000005868	       366        1  ___U_lA____Ma_b_________________	uptodate,lru,active,mmap,anonymous,swapbacked
0x000000000000586c	         1        0  __RU_lA____Ma_b_________________	referenced,uptodate,lru,active,mmap,anonymous,swapbacked
             total	    255744      999
