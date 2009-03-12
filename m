Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbZCLQBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbZCLQBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZCLQBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:01:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:41978 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZCLQBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:01:33 -0400
MIME-Version: 1.0
In-Reply-To: <ed82fe3e0903120854r2d8f23d8r249a8e510a2fbc4c@mail.gmail.com>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
	 <1236729711.7086.28.camel@pasglop>
	 <20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>
	 <ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>
	 <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>
	 <49B80081.5060703@freescale.com> <1236808722.7086.66.camel@pasglop>
	 <fa686aa40903111945g53a0ba5au200fe9362e315175@mail.gmail.com>
	 <ed82fe3e0903120854r2d8f23d8r249a8e510a2fbc4c@mail.gmail.com>
Date: Thu, 12 Mar 2009 10:01:27 -0600
Message-ID: <fa686aa40903120901me307a54y3511f4bafc6242e6@mail.gmail.com>
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Grant Likely <grant.likely@secretlab.ca>
To: Timur Tabi <timur@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, peterz@infradead.org,
       will.newton@gmail.com, hancockrwd@gmail.com, jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 9:54 AM, Timur Tabi <timur@freescale.com> wrote:
> On Wed, Mar 11, 2009 at 9:45 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
>>> The other big advantage of that approach is that drivers that aren't in
>>> an atomic section can use msleep() and allow the kernel to schedule on
>>> that processor.
>>
>> Ack!  I totally agree.
>
> I'm glad everyone agrees.  I still don't know how to solve the
> problem, though.  I came up with this:
>
> #define spin_until_timeout(condition, timeout)          \
>       for (unsigned long __timeout = jiffies + (timeout);     \
>               (!(condition) && time_after(jiffies, __timeout)); )
>
> Now how do I modify this so that the caller knows whether the loop
> terminated because of a timeout or the condition became true?

How about this:

#define spin_until_timeout(condition, timeout, rc)          \
      for (unsigned long __timeout = jiffies + (timeout);     \
              (!(rc = (condition)) && time_after(jiffies, __timeout)); )

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
