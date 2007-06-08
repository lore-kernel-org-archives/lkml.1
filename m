Return-Path: <linux-kernel-owner+w=401wt.eu-S939490AbXFHIIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939490AbXFHIIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939425AbXFHHu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:50:26 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:28297 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939424AbXFHHuY (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:50:24 -0400
Message-ID: <46690A39.3010402@de.ibm.com>
Date: Fri, 08 Jun 2007 09:50:17 +0200
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
References: <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com> <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com> <20070607193844.GB17144@infradead.org> <4669027E.3070406@de.ibm.com> <20070608072609.GA13115@infradead.org>
In-Reply-To: <20070608072609.GA13115@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> We can have a simpler variant as a start if we really want.  But we
> need to pass it through the mtd layer.  There is a reason we have this
> thing called devices drivers, and we don't want to add knowledge of
> ioremap to the filesystems and have users find out physical addresses
> of their flash to pass it as mount option.
I see your poing with regard to layering, and I agree to it.
In order to do ioremap/iounmap at least we need a counterpart 
put_xip_page thing to do iounmap in that path. Our dcss segments on 
390 did not raise that requirement: they had a permanent kernel mapping.
The quiz question to me is: why don't we establish a permanenet 
mapping of the entire thing from mount() to unmount(). That eliminates 
the need to do iomap/iounmap, eliminates the need to have 
put_xip_page, and eliminates to care about what layer would do this. 
Would work for cramfs, won't work for read+write flash filesystems.
