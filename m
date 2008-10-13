Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbYJMSzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbYJMSzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbYJMSy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:54:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:61238 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757876AbYJMSy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:54:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,404,1220252400"; 
   d="scan'208";a="347554548"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: bibo mao <bibo.mao@gmail.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Date: Mon, 13 Oct 2008 11:49:21 -0700
Subject: RE: [patch 0/1]pat: remove redundant condition check
Thread-Topic: [patch 0/1]pat: remove redundant condition check
Thread-Index: AckscVEw4aMs7yQ8QX2GCgg42Ar7zgA8qiSA
Message-ID: <7E82351C108FA840AB1866AC776AEC463796A2BF@orsmsx505.amr.corp.intel.com>
References: <fbd277f20810120645g7feb4b85g49211641829e153e@mail.gmail.com>
In-Reply-To: <fbd277f20810120645g7feb4b85g49211641829e153e@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of bibo mao
>Sent: Sunday, October 12, 2008 6:45 AM
>To: akpm@linux-foundation.org
>Cc: linux-kernel@vger.kernel.org
>Subject: [patch 0/1]pat: remove redundant condition check
>
>On file pat.c, if (start <= entry->start), it also means (start <
>entry->end). This patch removes
>redundant condition check.
>

No No.

start <= entry->start does mean start < entry->end
but
start <= entry->end does NOT mean start < entry->start

This 'else if' is to catch the cases where start < entry->end
and start > entry->start. Removing it will break the whole
logic of this function.

Thanks,
Venki

>Signed-off-by: bibo.mao@gmail.com
>thanks
>bibo,mao
>
>------------------------------------------------------
>diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
>index 2a50e0f..12cac5e 100644
>--- a/arch/x86/mm/pat.c
>+++ b/arch/x86/mm/pat.c
>@@ -305,27 +305,6 @@ int reserve_memtype(u64 start, u64 end, unsigned
>long req_type,
>                                                        struct
>memtype, nd);
>                        }
>                        break;
>-               } else if (start < entry->end) { /* start >
>entry->start */
>-                       err = chk_conflict(new, entry, new_type);
>-                       if (!err) {
>-                               dprintk("Overlap at 0x%Lx-0x%Lx\n",
>-                                       entry->start, entry->end);
>-                               cached_entry =
>list_entry(entry->nd.prev,
>-                                                       struct
>memtype, nd);
>-
>-                               /*
>-                                * Move to right position in the linked
>-                                * list to add this new entry
>-                                */
>-                               list_for_each_entry_continue(entry,
>-
>&memtype_list, nd) {
>-                                       if (start <= entry->start) {
>-                                               where = entry->nd.prev;
>-                                               break;
>-                                       }
>-                               }
>-                       }
>-                       break;
>                }
>        }
>--
>To unsubscribe from this list: send the line "unsubscribe
>linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
