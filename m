Return-Path: <linux-kernel-owner+w=401wt.eu-S933635AbXFGRIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbXFGRIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763382AbXFGRH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:07:59 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:29788 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761088AbXFGRH6 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:07:58 -0400
Message-ID: <46683B6A.6030306@de.ibm.com>
Date: Thu, 07 Jun 2007 19:07:54 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, carsteno@de.ibm.com,
       Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com> <20070606162305.GA20600@infradead.org>
In-Reply-To: <20070606162305.GA20600@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> The right way to architect xip for flash-based devices is to implement
> a generic get_xip_page for mtd-based devices and integrate that into
> an existing flash filesystem or write a simple new flash filesystem
> tailored to that use case.
I've had a few beer long discussion with Joern Engel and David 
Woodhouse on this one. To cut a long discussion short: the current XIP 
infrastructure is not sufficient to be used on top of mtd. We'd need 
some extenstions:
- on get_xip_page() we'd need to state if we want the reference 
read-only or read+write
- we need a put_xip_page() to return references
- and finally we need a callback for the referece, so that the mtd 
driver can ask to get its reference back (in order to unmap from 
userland when erasing a block)

While I fully agree, that a flash filesystem using xip would be very 
desireable, the proposed cramfs extension is a totaly different beast 
that has its own value to me: the ability to select per file whether 
xip or compression is more efficient.
