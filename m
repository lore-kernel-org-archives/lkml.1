Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYIIStR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYIIStR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYIIStE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:49:04 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:64038 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYIIStB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:49:01 -0400
Message-ID: <48C6C520.5070103@colorfullife.com>
Date: Tue, 09 Sep 2008 20:49:04 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, sparclinux@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] prevent sparc64 from invoking irq handlers on offline
 CPUs
References: <20080903004211.GD6748@linux.vnet.ibm.com> <20080903.022138.31681256.davem@davemloft.net> <20080903154217.GA6807@linux.vnet.ibm.com> <20080908.171708.43575256.davem@davemloft.net>
In-Reply-To: <20080908.171708.43575256.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> And IPI handler runs in HW irq context, therefore such an IPI-creates-an-IPI
> should not be allowed, at least not directly.
>
> Actually the restriction seems to be that an IPI cannot be sent when
> "irqs_disabled()", hmmm...
>
>   
Does this apply to smp_send_reschedule() as well?
A [rare] codepath in the current rcu code does to trigger quiescent 
states on remote cpus.

--
    Manfred

