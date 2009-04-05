Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbZDEQLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbZDEQLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 12:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZDEQLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 12:11:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54786 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZDEQLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 12:11:00 -0400
Message-ID: <49D8D809.8040503@redhat.com>
Date: Sun, 05 Apr 2009 19:10:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <200904011638.45135.rusty@rustcorp.com.au> <49D391F5.4080700@codemonkey.ws> <200904051314.23170.rusty@rustcorp.com.au> <49D8BC87.8030401@codemonkey.ws>
In-Reply-To: <49D8BC87.8030401@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
>
> What we need is:
>
> 1) Lockless MMIO/PIO dispatch (there should be two IO registration 
> interfaces, a new lockless one and the legacy one)

Not sure exactly how much this is needed, since when there is no 
contention, locks are almost free (there's the atomic and cacheline 
bounce, but no syscall).

For any long operations, we should drop the lock (of course we need some 
kind of read/write lock or rcu to avoid hotunplug or reconfiguration).

> 2) A virtio-net thread that's independent of the IO thread.

Yes -- that saves us all the select() prologue (calculating new timeout) 
and the select() itself.



-- 
error compiling committee.c: too many arguments to function

