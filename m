Return-Path: <linux-kernel-owner+w=401wt.eu-S1761242AbYDRX0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbYDRX0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYDRXXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:23:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39075 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbYDRXXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:23:16 -0400
Message-ID: <48092CFC.9090708@cs.helsinki.fi>
Date: Sat, 19 Apr 2008 02:21:32 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] slub: add hooks for kmemcheck
References: <20080418220339.GC16586@damson.getinternet.no>  <Pine.LNX.4.64.0804181507130.31394@schroedinger.engr.sgi.com> <19f34abd0804181527i3b65e82bk2a5d8b3c2b196f9e@mail.gmail.com> <Pine.LNX.4.64.0804181604310.4046@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0804181604310.4046@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Christoph Lameter wrote:
>>>  Should this not go into some kmemcheck.h file?
>> The implementations of these prototypes are in mm/slub_kmemcheck.c.
>> They are only ever called from slub.c since they represent the
>> interface between SLUB and kmemcheck.
>>
>> Would you rather have it in include/linux/slub_kmemcheck.h?
> 
> Well lets see what Pekka says.

Well, I've tried to push for "generic" kmemcheck hooks so that they can 
be used by SLAB/SLOB too but Vegard has always talked me out of it. Of 
course, I have long forgotten the rationale.

But anyway, slub_kmemcheck.h sounds okay and I wonder if we should put 
it in mm/ instead of include/linux/ as it's not supposed to be included 
by anyone except SLUB?

Christoph Lameter wrote:
>> Currently, with SLAB/SLUB debugging enabled, the page flag will be
>> cleared, then accessed in check_object(), thus generating a few
>> accesses to the page. It is safer to delay the clearing of the page
>> flag until no more accesses can be generated for the page.
> 
> Hmmmm.. Okay that is already dealt with by a patch in Pekka's tree.

And merged by Linus now.

			Pekka
