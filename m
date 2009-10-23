Return-Path: <linux-kernel-owner+w=401wt.eu-S1751535AbZJWR2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbZJWR2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 13:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZJWR2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 13:28:09 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:47160 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZJWR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 13:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ALRLfLZOkaEBlZiXuM2Vz3vuQWHvN+I4qSgzAZ849jWBki8+cyV4Zvw+1jQbYGMmzQ
         Xl7UV9DiYUvWmanxxsbUNQ+L7zYeWDMmcpJ8X6kRHPS90PzAHPemUs5kO0YWAE6ZhyZM
         1PRCPgPZrj1S0p8tdJI0PmzgFY0RO+Zw+DDQs=
MIME-Version: 1.0
In-Reply-To: <m13a5apmm0.fsf@fess.ebiederm.org>
References: <4AE0D14B.1070307@caviumnetworks.com> <4AE0D72A.4090607@nortel.com>
	 <4AE0DB98.1000101@caviumnetworks.com>
	 <m13a5apmm0.fsf@fess.ebiederm.org>
Date: Fri, 23 Oct 2009 10:28:10 -0700
Message-ID: <4807377b0910231028g60b479cfycdbf3f4e25384c58@mail.gmail.com>
Subject: Re: Irq architecture for multi-core network driver.
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Chris Friesen <cfriesen@nortel.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 12:59 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> David Daney <ddaney@caviumnetworks.com> writes:
>> Certainly this is one mode of operation that should be supported, but I would
>> also like to be able to go for raw throughput and have as many cores as possible
>> reading from a single queue (like I currently have).
>
> I believe will detect false packet drops and ask for unnecessary
> retransmits if you have multiple cores processing a single queue,
> because you are processing the packets out of order.

So, the way the default linux kernel configures today's many core
server systems is to leave the affinity mask by default at 0xffffffff,
and most current Intel hardware based on 5000 (older core cpus), or
5500 chipset (used with Core i7 processors) that I have seen will
allow for round robin interrupts by default.  This kind of sucks for
the above unless you run irqbalance or set smp_affinity by hand.

Yes, I know Arjan and others will say you should always run
irqbalance, but some people don't and some distros don't ship it
enabled by default (or their version doesn't work for one reason or
another)  The question is should the kernel work better by default
*without* irqbalance loaded, or does it not matter?

I don't believe we should re-enable the kernel irq balancer, but
should we consider only setting a single bit in each new interrupt's
irq affinity?  Doing it with a random spread for the initial affinity
would be better than setting them all to one.
