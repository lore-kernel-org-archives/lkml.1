Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZD1VGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZD1VGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZD1VGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:06:03 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:45116 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZD1VGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:06:01 -0400
Message-ID: <49F76F6C.80005@cosmosbay.com>
Date: Tue, 28 Apr 2009 23:04:44 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       jesse.brandeburg@intel.com, netdev@vger.kernel.org, haoki@redhat.com,
       mchan@broadcom.com, davidel@xmailserver.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] poll: Avoid extra wakeups in select/poll
References: <alpine.DEB.1.10.0904241554100.29995@qirst.com> <49F3308B.1030507@cosmosbay.com> <20090426.020411.157511269.davem@davemloft.net> <49F43B8F.2050907@cosmosbay.com> <87ab60rh8t.fsf@basil.nowhere.org> <49F71B63.8010503@cosmosbay.com> <alpine.DEB.1.10.0904281501300.13862@qirst.com> <49F76174.6060009@cosmosbay.com> <alpine.DEB.1.10.0904281612560.13862@qirst.com> <49F767FD.2040205@cosmosbay.com> <alpine.DEB.1.10.0904281629090.15947@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0904281629090.15947@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 28 Apr 2009 23:04:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Tue, 28 Apr 2009, Eric Dumazet wrote:
> 
>> The one that did improved your udpping 'bench' :)
>>
>> http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=bf368e4e70cd4e0f880923c44e95a4273d725ab4
> 
> Well yes that is git2p1. The measurements that we took showed not much of
> an effect as you see.
> 

It depends of coalescing parameters of NIC.

BNX2 interrupts first handle TX completions, then RX events.
So If by the

