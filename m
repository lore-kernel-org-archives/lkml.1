Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbXFOJWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbXFOJWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXFOJWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:22:31 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:42534 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbXFOJW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:22:29 -0400
Message-ID: <46725A4D.1040404@de.ibm.com>
Date: Fri, 15 Jun 2007 11:22:21 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Heiko Carstens <h.carstens@de.ibm.com>
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706121711m738bd9abqa02350ccc7eabf9f@mail.gmail.com> <4671495A.3020605@de.ibm.com> <6934efce0706140953x2167944fr54eca6376e1f8d63@mail.gmail.com>
In-Reply-To: <6934efce0706140953x2167944fr54eca6376e1f8d63@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
>> An alternative approach, which does not need to have struct page at
>> hand, would be to use the nopfn vm operations struct. That one would
>> have to rely on get_xip_pfn.
> Of course!  Okay now I'm begining to understand.
Sorry, but I think I was educated yesterday that ->fault() (only in 
-mm) is where we'd be heading. Nopfn is deprecated. But conceptually, 
this does'nt change things.

>> The current path would then be deprecated.
> Why?  Wouldn't both paths be valid options?
The new path via fault works in both cases with and without struct 
page behind. No need to keep the old one as far as I see.

>> If you're interrested in using the later for xip without
>> struct page, I would volounteer to go ahead and implement this?
> I'm very interested in this.
Good. Let me see if I can come up with a patch on this.

> I'm not opposed to using struct page, but I'm confused as to how to
> start that.  As I understand it, which is not well, defined a
> CONFIG_DISCONTIGMEM region to cover the Flash memory would add that to
> my pool of RAM.  That would be 'bad', right?  I don't see how to
> create the page structs and set this memory aside as different.
I fear I am not the right person to answer that question. In the good 
old days before discontigmem/sparse mem/vmem map where invented we 
used to have a hack for that in arch/. Heiko then decided my hack is a 
mess and came up with a good solution to the problem.

so long,
Carsten
