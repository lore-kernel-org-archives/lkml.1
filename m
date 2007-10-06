Return-Path: <linux-kernel-owner+w=401wt.eu-S1764404AbXJFAhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764404AbXJFAhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 20:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbXJFAhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 20:37:13 -0400
Received: from ns.ariel-networks.com ([124.39.57.10]:43758 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbXJFAhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 20:37:12 -0400
X-Greylist: delayed 1987 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2007 20:37:11 EDT
To: linux-kernel@vger.kernel.org
Subject: [PATCH]dose it make get_swap_page(mm/swapfiles.c) good performance ?, kernel<2.6.22.9>.
Message-Id: <20071006000403.DF6E2378020@ns.ariel-networks.com>
Date: Sat,  6 Oct 2007 09:04:03 +0900 (JST)
From: ohyama_sec@ariel-networks.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-hiroyasu ohyama

I wonder what corrected attached source makes good performance of 
getting page slot cluster from page area discripter which is written 
"si" in the source codes.
Because I think head of swap_list_t discripter doesn't suggest index of 
swap area which is same priority that swap_list.next but one which is 
the highest priority in the priority's list.
the si->swap_map which have high priority may be chosen by 
get_swap_page(), so that page slot of low priority's swap area may have 
more blank cluster than one of hich priority's swap area.
Then, I think substitute "swap_list.head" for "next" is privent them 
from finding cluster of page slot when "swap_info[next].prio"'s priority 
is different swap_list.next.

---

*** mm/swapfile_bck.c   2007-10-04 12:09:37.000000000 +0900
--- mm/swapfile.c       2007-10-04 12:31:34.000000000 +0900
***************
*** 186,193 ****
       for (type = swap_list.next; type >= 0 && wrapped < 2; type = next) {
               si = swap_info + type;
               next = si->next;
!               if (next < 0 ||
!                   (!wrapped && si->prio != swap_info[next].prio)) {
                       next = swap_list.head;
                       wrapped++;
               }
--- 186,192 ----
       for (type = swap_list.next; type >= 0 && wrapped < 2; type = next) {
               si = swap_info + type;
               next = si->next;
!               if (next < 0) {
                       next = swap_list.head;
                       wrapped++;
               }



