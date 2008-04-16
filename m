Return-Path: <linux-kernel-owner+w=401wt.eu-S1762936AbYDPOVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762936AbYDPOVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbYDPOVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:21:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:47652 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbYDPOVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eLD7ER8YPki/oBetjM9Yy4IYNUA0Oe+ELtm7BqTUC8SlqV6aw0plaez7SUW9LJb9kq/i7njEd3/atrKnb5eCit3uhRjXn3TP2STiRywc0ogYG5SdjdKtQc1Rv5eTx+nJ9eEdyeY/w3wgZCvA0z71O4vS91xGJV2K136F9dZB4DI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Does process need to have a kernel-side stack all the time?
Date: Wed, 16 Apr 2008 16:20:43 +0200
User-Agent: KMail/1.8.2
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <200804141547.57719.vda.linux@googlemail.com> <87hce4uya8.fsf@basil.nowhere.org> <20080416124728.GA5050@elte.hu>
In-Reply-To: <20080416124728.GA5050@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804161620.43536.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008 14:47, Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Denys Vlasenko <vda.linux@googlemail.com> writes:
> > 
> > > A lot of effort went into minimizing of stack usage.
> > > If I understand it correctly, one of the reasons for this
> > > was to be efficient and not have lots of pages
> > > used for stacks when we have a lot of threads
> > > (tens of thousands).
> > 
> > Actually the real reason the 4K stacks were introduced IIRC was that 
> > the VM is not very good at allocation of order > 0 pages and that only 
> > using order 0 and not order 1 in normal operation prevented some 
> > stalls.
> 
> no, the primary motivation Arjan and me started working on 4K stacks and 
> implemented it was what Denys mentioned: i had a testcase that ran 
> 50,000 threads before it ran out of memory - i wanted it to run 100,000 
> threads. The improved order-0 behavior was just icing on the cake.

And my "random thought" occurred along the lines "Ingo once ran
100000 threads and then ran out of space for stack... wait a minute!
Why every single one of those threads need to have a stack at the same time?
They sure as hell can't actively use more than NR_CPUS stacks at once!".

Pity it wouldn't work.
--
vda
