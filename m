Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZJFITP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZJFITP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbZJFITO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:19:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:41710 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754335AbZJFITN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:19:13 -0400
Content-Type: text/plain; charset="utf-8"
Date: Tue, 06 Oct 2009 10:18:22 +0200
From: "Ronny Egner" <RonnyEgner@gmx.de>
Message-ID: <20091006081822.154790@gmx.net>
MIME-Version: 1.0
Subject: Question regarding Page Table size
To: linux-kernel@vger.kernel.org
X-Authenticated: #718584
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+kafMeBYikSf8qSC/1F+5FCw0xhLeMhj9hvkyu8Z
 DLTrlkOPvwr4cHlG7M6KybvhLdby2YqmnUaA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: es/4eUYLPTR+Fs/FOzIwuUY5c2tpZEtC
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kernel gurus,

i have a simple question but until now i did not find an answer. I beg your apologize if my question is misplaced.



So my question is:

"How much memory is needed in the kernel page table for a 
process accessing a shared memory segment?"


According to the information i have and found at the web the rule is:


"4 Bytes per 4 KB referenced memory per process is allocated 
in the page table"


However i found one note saying because shared memory is 
referenced 8 Bytes are needed:


--- BEGIN QUOTE ---
PageTables is memory to manage memory.

Each entry takes 4 bytes. Each 4 Kb of virtual (not swap) 
memory requires one PTE to manage. This also counts for 
shared memory, as with shared memory there is one physical 
segment, but each process has its own virtual memory which 
maps to this segment.

In Oracle’s case, assuming an SGA of 2 Gb, that is:

524,288 pages * 8 bytes = 4 Mb per process

--- END QUOTE ---
(Source: http://www.pythian.com/news/741/pythian-goodies-free-memory-swap-oracle-and-everything)

Until now i was not able to verify this information. So i am asking here
for more information or perhaps a link.


Where does the 8 byte in the calculation above come from?

Taking the above example with a 2 GB shared memory segment the space 
needed in the page table should be:

 524288 pages * 4 Bytes = 2 MB 
     (for the process "owning" the shared memory segment)

 PLUS

 524288 pages * 4 Bytes = 2 MB 
     (for *every* process referencing the shared memory 
      segment assuming the fact the shared memory segment 
      is referenced completely)




Could anybody please give me a hint?


Thanks in advance



-- 
Ronny Egner
-- 
Ronny Egner
RonnyEgner@gmx.de

