Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZGPMzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZGPMzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbZGPMzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:55:41 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52463 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbZGPMzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:55:40 -0400
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>, linux-mtd@lists.infradead.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090716124133.25463.33849.sendpatchset@subratamodak.linux.ibm.com>
References: <20090716124133.25463.33849.sendpatchset@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jul 2009 15:54:45 +0300
Message-Id: <1247748885.11353.156.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Jul 2009 12:54:51.0250 (UTC) FILETIME=[9B900520:01CA0614]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 18:11 +0530, Subrata Modak wrote:
> does not use:
> 	"const struct ubifs_info *c"
> inside the inline function. I do not see any practical usage of
> "const struct ubifs_info *c" in the functions key_read() and key_write().
> Is there something which i am missing to understand ?
> 
> When i applied the following patch, still the "fs/ubifs/" code compiled fine.
> If the below fix is correct, i can try fixing some other functions i saw
> having similar defects.

Yeah, I think the reason why we have this extra argument there is that
we assumed there will be several key schemes. It is possible to add more
than one, but we use only one.

Since you have already spent your time for this, could you please check
if removing this 'c' makes the code smaller? If not, I'd prefer not to
remove it.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

