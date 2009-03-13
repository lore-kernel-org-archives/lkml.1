Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZCMEvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZCMEvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbZCMEvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:51:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:14212 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZCMEvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <1236913421.25062.19.camel@pasglop>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <49B80081.5060703@freescale.com> <1236808722.7086.66.camel@pasglop>
	 <fa686aa40903111945g53a0ba5au200fe9362e315175@mail.gmail.com>
	 <ed82fe3e0903120854r2d8f23d8r249a8e510a2fbc4c@mail.gmail.com>
	 <fa686aa40903120901me307a54y3511f4bafc6242e6@mail.gmail.com>
	 <49B9362D.3090805@freescale.com> <1236876609.5090.934.camel@laptop>
	 <ed82fe3e0903121205k552a83bft9ac3b63c64a293c8@mail.gmail.com>
	 <1236913421.25062.19.camel@pasglop>
Date: Thu, 12 Mar 2009 22:51:10 -0600
Message-ID: <fa686aa40903122151s1bce1a18x156130b97f4d19cd@mail.gmail.com>
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Grant Likely <grant.likely@secretlab.ca>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Timur Tabi <timur@freescale.com>, Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, will.newton@gmail.com,
       hancockrwd@gmail.com, jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 9:03 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
>> But that's the thing - I don't want a required delay inside the loop.
>>
>> I guess I'm going to have to think about this for a while.  I'd like
>> to see something like cycles_per_usec() as a companion function to
>> get_cycles().
>
> I think that's where you're wrong :-)

And I disagree.  :-)

> Just require the delay inside the loop, it will make everything nicer.
> There are also some good reasons to do that:
>
>  - The delay between "polls" of the register may have to be controlled,
> for example some HW will choke if polled too fast

Yes, but not all HW does.  There have been several times that I've
needed to spin on a register without any delay.  Requiring the loop
block to include an explicit delay nullifies most of usefulness to me.

>  - If you aren't in an atomic section, you may want to use msleep() and
> thus be schedule friendly

This I agree with, and I see a real use for.  However, if the contents
of the block don't have any form of constant delay, then it is less
clear how long the loop is going to run for.

OTOH, for the kind of delays that I see myself using it for, it if
doesn't have a resolution in the range of timebase ticks, then it
probably isn't going to be useful for me.  I certainly am not
interested in spinning for more than a handful of ticks if I can help
it.

>  - It fixes all the problems mentioned earlier

On another note; I'd consider calling it loop_event_timeout() instead
of spin_event_timeout() since it would allow the block contents to
sleep, and hence it wouldn't be spinning anymore.  :-)

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
