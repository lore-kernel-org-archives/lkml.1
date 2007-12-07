Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbXLGJAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbXLGJAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 04:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbXLGI7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 03:59:53 -0500
Received: from mout2.freenet.de ([195.4.92.92]:33622 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbXLGI7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 03:59:51 -0500
Message-ID: <47590B7E.5040608@de.ibm.com>
Date: Fri, 07 Dec 2007 09:59:42 +0100
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: Rob Landley <rob@landley.net>, carsteno@de.ibm.com,
       Nick Piggin <npiggin@suse.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] ext2: xip check fix
References: <20071204042628.GA26636@wotan.suse.de> <20071206101848.GC25202@wotan.suse.de> <4757CDD4.5090606@de.ibm.com> <200712061211.49443.rob@landley.net> <6934efce0712061922j682cee55pc1d5d079465f4849@mail.gmail.com>
In-Reply-To: <6934efce0712061922j682cee55pc1d5d079465f4849@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Warning: de.ibm.com is listed at abuse.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> I think so.  The filemap_xip.c functionality doesn't work for Flash
> memory yet.  Flash memory doesn't have struct pages to back it up with
> which this stuff depends on.
Struct page is not the major issue. The primary problem is writing to 
the media (and I am not a flash expert at all, just relaying here): 
For some period of time, the flash memory is not usable and thus we 
need to make sure we can nuke the page table entries that we have in 
userland page tables. For that, we need a callback from the device so 
that it can ask to get its references back. Oh, and a put_xip_page 
counterpart to get_xip_page, so that the driver knows when it's safe 
to erase.

cheers,
Carsten
