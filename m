Return-Path: <linux-kernel-owner+w=401wt.eu-S1761833AbYDOIS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761833AbYDOIS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYDOISK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:18:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39460
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755387AbYDOISJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:18:09 -0400
Date: Tue, 15 Apr 2008 01:18:10 -0700 (PDT)
Message-Id: <20080415.011810.178212948.davem@davemloft.net>
To: andi@firstfloor.org
Cc: vgusev@openvz.org, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH][NET] Fix never pruned tcp out-of-order queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <87iqyjttz3.fsf@basil.nowhere.org>
References: <87mynvtuoj.fsf@basil.nowhere.org>
	<20080415.010131.156668601.davem@davemloft.net>
	<87iqyjttz3.fsf@basil.nowhere.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 15 Apr 2008 10:14:56 +0200

> The main difference seems to be that
> sk_rmem_schedule/__sk_mem_schedule is called more often, but it is 
> unclear how this affects the ooo pruning which only checks
> the queue length anyways.

tcp_data_queue() would not do the tcp_prune_ofo_queue() in some
cases, it's the whole point of the patch.
