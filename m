Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbYHRKu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbYHRKu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYHRKus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:50:48 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:56590 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYHRKur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:50:47 -0400
Message-ID: <48A95400.5050003@de.ibm.com>
Date: Mon, 18 Aug 2008 12:50:40 +0200
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
Subject: Re: [patch] mm: xip fix fault vs sparse page invalidate race
References: <20080818053821.GA3011@wotan.suse.de> <20080818054409.GB3011@wotan.suse.de>
In-Reply-To: <20080818054409.GB3011@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> XIP has a race between sparse pages being inserted into page tables, and
> sparse pages being zapped when its time to put a non-sparse page in.
> 
> What can happen is that a process can be left with a dangling sparse page
> in a MAP_SHARED mapping, while the rest of the world sees the non-sparse
> version. Ie. data corruption. 
> 
> Guard these operations with a seqlock, making fault-in-sparse-pages
> the slowpath, and try-to-unmap-sparse-pages the fastpath.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
Ouch.
Acked-by: Carsten Otte <cotte@de.ibm.com>
