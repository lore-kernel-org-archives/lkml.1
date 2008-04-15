Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYDOIBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYDOIBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbYDOIBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:01:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33157
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753990AbYDOIBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:01:30 -0400
Date: Tue, 15 Apr 2008 01:01:31 -0700 (PDT)
Message-Id: <20080415.010131.156668601.davem@davemloft.net>
To: andi@firstfloor.org
Cc: vgusev@openvz.org, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH][NET] Fix never pruned tcp out-of-order queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <87mynvtuoj.fsf@basil.nowhere.org>
References: <200804142121.53860.vgusev@openvz.org>
	<87mynvtuoj.fsf@basil.nowhere.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 15 Apr 2008 09:59:40 +0200

> Vitaliy Gusev <vgusev@openvz.org> writes:
> 
> > Hello!
> >
> > tcp_prune_queue() doesn't prune an out-of-order queue at all.
> 
> Why are you saying this? It has code to prune the ooo queue. You're even
> moving it in your patch.
> 
> You're saying that the code doesn't work? If yes why? 

There are inappropriate guards there, and it didn't get invoked
from another important code path.

That's what his change is fixing.

