Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbZGPMMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbZGPMMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZGPMMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:12:20 -0400
Received: from smtp.nokia.com ([192.100.122.230]:44905 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbZGPMMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:12:19 -0400
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>, linux-mtd@lists.infradead.org,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A5F15B0.9030100@s5r6.in-berlin.de>
References: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com>
	 <1247640750.11353.6.camel@localhost.localdomain>
	 <4A5E1D1A.3090705@s5r6.in-berlin.de>
	 <1247738232.11353.90.camel@localhost.localdomain>
	 <4A5F0F03.5080507@s5r6.in-berlin.de>  <4A5F15B0.9030100@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jul 2009 15:11:30 +0300
Message-Id: <1247746290.11353.146.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Jul 2009 12:11:36.0471 (UTC) FILETIME=[90F42A70:01CA060E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 13:57 +0200, Stefan Richter wrote:
> Stefan Richter wrote:
> > So, is uninitialized_var() a good fix here?  I'd say it's not a 
> > particular good one.  Count the lines of code of dbg_check_old_index() 
> > and the maximum indentation level of it.  Then remember the teachings of 
> > CodingStyle. :-)  See?  dbg_check_old_index() clearly isn't a prime 
> > example of best kernel coding practice.  /Perhaps/ a little bit of 
> > refactoring would make it easier to read, and as a bonus side effect, 
> > make it unnecessary to use the slightly dangerous and 
> > uninitialized_var() macro here.
> 
> PS:
> On the other hand, it is debug code.  Is it bound to stay in there 
> forever?  If not, then it's surely not worth the developer time to 
> beautify it.

Yes, it is debugging code. It is doing additional consistency/sanity
checks of the internal data structures when you compile it in and enable
it. And yes, I'd like it to stay there forever, because it is a very
nice tool to catch bugs. In fact, I am really keen of this type of
debugging when you have internal checking functions. They help a lot.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

