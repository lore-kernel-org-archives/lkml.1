Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYG2Wej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYG2Wej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbYG2WeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:34:19 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:37661 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbYG2WeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:34:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=P/w1SF+l6Xes+2P2BdUoG5CR9R/VxannjfCQIT56sCNFMIHXfqzE2LXoTVykk+X9R7f4hcDeQ21wwEQPFlAd6bvCelfySs3NvsE3BHGVzSdQWJ4sS0nBDukfpxUGOH5T;
Message-ID: <488F9AE3.8040207@simon.arlott.org.uk>
Date: Tue, 29 Jul 2008 23:34:11 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Alan Stern <stern@rowland.harvard.edu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [patch 5/3] fastboot: sync the async execution before late_initcall
 and move level 6s (sync) first
References: <20080720085924.122feb2b@infradead.org>	<20080720090041.5924f5ff@infradead.org>	<488F84ED.9010200@keyaccess.nl>	<20080729140434.31022f55@infradead.org>	<488F87AB.9080309@keyaccess.nl> <20080729142123.5164b1a4@infradead.org> <488F99EB.2030808@keyaccess.nl>
In-Reply-To: <488F99EB.2030808@keyaccess.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/08 23:30, Rene Herman wrote:
> On 29-07-08 23:21, Arjan van de Ven wrote:
> 
>> On Tue, 29 Jul 2008 23:12:11 +0200
>> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>>> After this patch, there are now 2 flush_workqueue(async_init_wq)
>>> calls in do_initcalls. Should the other one remain as well?
>>
>> yes because if you don't have any level 7's then you won't hit this
>> condition... you need the second one.
>>
>> flush_workqueue is cheap for the nothing-in-there case.
> 
> Ah, yes.
> 
> For what it's worth by the way, I'm running that which is available from 
> your fastboot repo (12 patches currently) on top of 2.6.26. Not seen any 
> trouble. Nor improvements that I've noticed but this is a rather minimal 
> and fast booting kernel/system anyway.

It doesn't appear to be possible to init multiple PCI devices at once... 
I haven't looked into what is doing it exactly but presumably there's a 
lock being held over the whole device probe process.

The speedup from usb seems to be primarily from initialising devices in 
the background... perhaps there's some way to do that without doing hcd 
init from a second thread?

I get a really slow booting system if I enable the SAS controller... it 
requires 14 seconds to initialise itself, even with no drives attached 
(LSI 1068E).

-- 
Simon Arlott
