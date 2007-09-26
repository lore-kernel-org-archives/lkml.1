Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbXIZMBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbXIZMBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 08:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbXIZMBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 08:01:41 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:12153 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbXIZMBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 08:01:40 -0400
Message-ID: <46FA4916.10103@emc.com>
Date: Wed, 26 Sep 2007 07:57:10 -0400
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>,
       Chris Mason <chris.mason@oracle.com>, Mark Lord <mlord@pobox.com>,
       Valerie Henson <val.henson@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>
CC: Bob Bell <b_lkml@thebellsplace.com>, Matthew Wilcox <matthew@wil.cx>,
       trond@netapp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TASK_KILLABLE version 2
References: <20070924201648.GA6850@newbie.thebellsplace.net>
In-Reply-To: <20070924201648.GA6850@newbie.thebellsplace.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.51425
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __FRAUD_419_BADTHINGS 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Bell wrote:
> On Sat, Sep 01, 2007 at 08:43:49PM -0600, Matthew Wilcox wrote:
>> Here's the second version of TASK_KILLABLE.  A few changes since 
>> version 1:
> <snip>
>> I obviously haven't covered every place that can result in a process
>> sleeping uninterruptibly while attempting an operation.  But sync_page
>> (patch 4/5) covers about 90% of the times I've attempted to kill cat,
>> and I hope that by providing the two examples, I can help other people
>> to fix the cases that they find interesting.
> 
> I've been testing this patch on my systems.  It's working for me when
> I read() a file.  Asynchronous write()s seem okay, too.  However,
> synchronous writes (caused by either calling fsync() or fcntl() to
> release a lock) prevent the process from being killed when the NFS
> server goes down.

After hearing again last month about how few people actually read every 
lkml thread, I  wanted to point you all at this thread explicitly since 
it seems that we are getting somewhat close to having a forced unmount 
that actually is usable by real applications, something that we seem to 
have been talking about for many years ;-)

With Matthew's original TASK_KILLABLE patch, we have a solution for a 
task read, but still have some holes (fsync & fcntl, others?) that need 
fixed as well for NFS clients.

Is this patch going in the right direction?

ric



