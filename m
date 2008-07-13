Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYGMTqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYGMTqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbYGMTqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:46:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54485
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754599AbYGMTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:46:10 -0400
Date: Sun, 13 Jul 2008 12:46:10 -0700 (PDT)
Message-Id: <20080713.124610.193703496.davem@davemloft.net>
To: andi@firstfloor.org
Cc: mpatocka@redhat.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <487A083F.9010301@firstfloor.org>
References: <87iqvb2skz.fsf@basil.nowhere.org>
	<Pine.LNX.4.64.0807130933120.24489@devserv.devel.redhat.com>
	<487A083F.9010301@firstfloor.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Sun, 13 Jul 2008 15:50:55 +0200

> Still I would expect that modern IO controllers are typically fast
> enough at processing SG lists that it shouldn't matter much.

I know it matters a lot on sparc64 ESP scsi controllers.

You can only have one address/len pair DMA'ing at a time and you have
to service an interrupt to load in the the next DMA sg elements into
the chips registers.

Merging is essentially a must for performance on those cards.
