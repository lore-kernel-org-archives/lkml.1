Return-Path: <linux-kernel-owner+w=401wt.eu-S1765613AbXFSCTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765613AbXFSCTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762794AbXFSCSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:18:51 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:59035 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104AbXFSCSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:18:51 -0400
Message-ID: <46773D08.8070103@alcatel-lucent.com>
Date: Tue, 19 Jun 2007 10:18:48 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, jinminc@alcatel-lucent.com
Subject: Re: Questions on one PowerPC assembly instruction from hash_page
References: <200706180857.l5I8vT6H000980@harpo.it.uu.se>
In-Reply-To: <200706180857.l5I8vT6H000980@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jun 2007 02:18:34.0261 (UTC) FILETIME=[232F4C50:01C7B218]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> On Mon, 18 Jun 2007 16:33:22 +0800, gshan <gshan@alcatel-lucent.com> wrote:
>   
>> I can't understand the following instructions from 
>> arch/ppc/mm/hashtable.S::hash_page. If I got the right design, the 
>> following instruction is to get the PMD (Page Middle Descritor) because 
>> Linux for 32-bits PowerPC cut page table into 3 domains: root, PMD, PTE. 
>> The top bits (22 to 31 bit) is the index for PMD, and the next 10 bits 
>> (12 to 21 bit) is the index for PTE in the associative PMD. The 
>> remaining 12 bits (0 to 11 bit) indicated the page size (4KB). However, 
>> the following instruction polled [8-17] bits instead of [22-31] bits as 
>> expected. Anybody could give me answer?
>>
>> r4 is the address that caused the DSI
>> r5 is the address of swapper_pg_dir if we are under kernel mode.
>>
>> rlwimi r5,r4,12,20,29 /* insert top 10 bits of address */
>>     
>
> POWER/PowerPC has an insanely broken bit numbering scheme, in
> which the most significant bit has number 0 (or is it 1?),
> and the least significant bit has number N-1 (or is it N?)
> where N is number of bits in a word.
>
> The fact that you refer to the top bits as 22-31 makes me
> suspect that you haven't compensated for this quirk.
>
> /Mikael
>   
Mikael, Thanks a lot. I understood why the instruction is there. So the 
0-11 bits are used as address index for PMD. swapper_pg_dir is 4KB large 
and there are 1K PMDs inside swapper_pg_dir. So 10 bits (0-9 bits) are 
used as index for PMD, right?
