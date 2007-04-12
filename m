Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXDLAXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXDLAXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 20:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965396AbXDLAXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 20:23:10 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3123 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965407AbXDLAXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 20:23:09 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Help Understanding Linux memory management
Date: Wed, 11 Apr 2007 17:23:00 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEKFCPAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <AD98412A5373CC4AA643D9C021922A541C4DC4@cdskitexg01.cds.int>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 11 Apr 2007 18:23:07 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 11 Apr 2007 18:23:08 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 1) When physical memory runs low, the memory manager will try to use
> memory currently allocated to the pagecache.  Is this true?

Yes.

> 2) When vm.overcommit_memory = 2 (overcommit disabled), and memory runs
> low, it appears that the memory manager does not try to use memory
> currently allocated to pagecache.  Is this true?

It does try, that doesn't mean it will succeed. If overcommit is disabled,
the OS must have enoug (RAM+swap) to handle the maximum memory consumption
is has allowed to take place.

Perhaps you are laboring under the incorrect assumption that the pagecache
can always be shrunk to zero? Not all the data in the pagecache is
discardable. For example, any page that has been modified from its disk copy
cannot be discarded.

> 3) Is it possible to disable the pagecache?

No, because huge amounts of capability would become impossible. It is not
even clear to me how you could execute self-modifying code without a
pagecache.

DS


