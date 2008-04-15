Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbYDOIYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbYDOIYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYDOIY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:24:26 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13139 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695AbYDOIYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:24:25 -0400
From: Vitaliy Gusev <vgusev@openvz.org>
To: David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH][NET] Fix never pruned tcp out-of-order queue
Date: Tue, 15 Apr 2008 12:26:47 +0400
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: andi@firstfloor.org, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org
References: <87mynvtuoj.fsf@basil.nowhere.org> <87iqyjttz3.fsf@basil.nowhere.org> <20080415.011810.178212948.davem@davemloft.net>
In-Reply-To: <20080415.011810.178212948.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804151226.47729.vgusev@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2008 12:18:10 David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Tue, 15 Apr 2008 10:14:56 +0200
> 
> > The main difference seems to be that
> > sk_rmem_schedule/__sk_mem_schedule is called more often, but it is 
> > unclear how this affects the ooo pruning which only checks
> > the queue length anyways.
> 
> tcp_data_queue() would not do the tcp_prune_ofo_queue() in some
> cases, it's the whole point of the patch.

Yes, if second sk_rmem_schedule() failed then tcp_prune_ofo_queue() is force called
and try sk_rmem_schedule() again.


-- 
Thank,
Vitaliy Gusev
