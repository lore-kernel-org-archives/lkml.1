Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZCLCqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZCLCqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZCLCqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:46:01 -0400
Received: from mail-gx0-f167.google.com ([209.85.217.167]:40126 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZCLCqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:46:00 -0400
MIME-Version: 1.0
In-Reply-To: <1236808722.7086.66.camel@pasglop>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
	 <1236729711.7086.28.camel@pasglop>
	 <20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>
	 <ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>
	 <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>
	 <49B80081.5060703@freescale.com> <1236808722.7086.66.camel@pasglop>
Date: Wed, 11 Mar 2009 20:45:57 -0600
Message-ID: <fa686aa40903111945g53a0ba5au200fe9362e315175@mail.gmail.com>
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Grant Likely <grant.likely@secretlab.ca>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Timur Tabi <timur@freescale.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com,
       peterz@infradead.org, will.newton@gmail.com, hancockrwd@gmail.com,
       jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 3:58 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2009-03-11 at 13:18 -0500, Timur Tabi wrote:
>> Alan Cox wrote:
>> >> Are you talking about the udelay() inside the loop?  If so, I agree
>> >> that this is bad and have removed it in the PowerPC-specific version:
>> >
>> > The behaviour you want there is system specific - 10uS is a minimum
>> > politeness value for x86 PCI bus for example.
>>
>> So we need to allow for delays between successive rights?  We can
>> provide that with a third parameter to the macro.
>
> I prefer Alan's method of having the macro be followed by { and } so we
> can add things in there. The delay between access will often be somewhat
> platform or device specific, and some drivers might be able to do useful
> things while spinning.
>
> The other big advantage of that approach is that drivers that aren't in
> an atomic section can use msleep() and allow the kernel to schedule on
> that processor.

Ack!  I totally agree.

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
