Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYHRKvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYHRKvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYHRKvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:51:14 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:42757 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYHRKvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:51:13 -0400
Message-ID: <48A9541C.9050506@de.ibm.com>
Date: Mon, 18 Aug 2008 12:51:08 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?BM_Deutschland_Research_=26_Developm?=
 =?ISO-8859-1?Q?ent_GmbH_/_Vorsitzender_des_Aufsichtsrats=3A_?=
 =?ISO-8859-1?Q?Martin_Jetter=2CGesch=E4ftsf=FChrung=3A_Herbert_Kir?=
 =?ISO-8859-1?Q?cher=2CSitz_der_Gesellschaft=3A_B=F6blingen_/_R?=
 =?ISO-8859-1?Q?egistergericht=3A_Amtsgericht_Stuttgart=2C_HRB_24?=
 =?ISO-8859-1?Q?3294?=
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, borntrae@linux.vnet.ibm.com,
       Jared Hulbert <jaredeh@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch] mm: xip/ext2 fix block allocation race
References: <20080818053821.GA3011@wotan.suse.de> <20080818054409.GB3011@wotan.suse.de> <20080818060301.GC3011@wotan.suse.de>
In-Reply-To: <20080818060301.GC3011@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> XIP can call into get_xip_mem concurrently with the same file,offset with
> create=1.  This usually maps down to get_block, which expects the page lock
> to prevent such a situation. This causes ext2 to explode for one reason or
> another.
> 
> Serialise those calls for the moment. For common usages today, I suspect
> get_xip_mem rarely is called to create new blocks. In future as XIP
> technologies evolve we might need to look at which operations require
> scalability, and rework the locking to suit.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Carsten Otte <cotte@de.ibm.com>
