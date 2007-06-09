Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbXFIIKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbXFIIKD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbXFIIJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:09:46 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:8882 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbXFIIJo (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:09:44 -0400
Message-ID: <466A6042.7030500@de.ibm.com>
Date: Sat, 09 Jun 2007 10:09:38 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Justin Treon <justin_treon_lkml@yahoo.com>
CC: carsteno@de.ibm.com, "\"JXrn\" Engel" <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <337240.79058.qm@web59309.mail.re1.yahoo.com>
In-Reply-To: <337240.79058.qm@web59309.mail.re1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Treon wrote:
> --- Carsten Otte <cotte@de.ibm.com> wrote:
>> The nice thing about this approach is: we use page->count and rmap, 
>> both already exist and are perfectly suited for our purpose.
>> The downside: We need mem_map[] struct page entries behind all memory 
>> segments. Nowerdays we can easily create those via vmem_map/sparsemem.
> Can you give an example of the proper way to use sparsemem in this case?  
We use vmem_map on 390:
- __segment_load[arch/s390/mm/extmem.c] calls add_shared_memory() to 
create struct page entries behind a segment
- segment_unload (same file) calls remove_shared_memory() to remove 
parts of the mem_map array again
- arch/s390/mm/vmem.c implements both callbacks

As far as I know, this can also be archived with sparsemem. 
Unfortunately I don't have an example for sparsemem at hand, I would 
try to use sparse_add_one_section()[mm/sparse.c].


sorry,
Carsten
