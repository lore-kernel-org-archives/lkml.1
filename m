Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZCLQVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZCLQVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZCLQVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:21:44 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:63419 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZCLQVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:21:43 -0400
Message-ID: <49B9362D.3090805@freescale.com>
Date: Thu, 12 Mar 2009 11:19:57 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, peterz@infradead.org,
       will.newton@gmail.com, hancockrwd@gmail.com, jeremy@goop.org
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
References: <1236699004-1863-1-git-send-email-timur@freescale.com>	 <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>	 <1236729711.7086.28.camel@pasglop>	 <20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>	 <ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>	 <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>	 <49B80081.5060703@freescale.com> <1236808722.7086.66.camel@pasglop>	 <fa686aa40903111945g53a0ba5au200fe9362e315175@mail.gmail.com>	 <ed82fe3e0903120854r2d8f23d8r249a8e510a2fbc4c@mail.gmail.com> <fa686aa40903120901me307a54y3511f4bafc6242e6@mail.gmail.com>
In-Reply-To: <fa686aa40903120901me307a54y3511f4bafc6242e6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:

> #define spin_until_timeout(condition, timeout, rc)          \
>       for (unsigned long __timeout = jiffies + (timeout);     \
>               (!(rc = (condition)) && time_after(jiffies, __timeout)); )

Ooo, that's good.

I'm still not crazy about using jiffies, since it doesn't get
incremented when interrupts are disabled, and I'd like this function to
work in those cases.  How about get_cycles()?  I know it's not supported
on all platforms, but I'm willing to live with that.

The other problem with get_cycles() is that there doesn't appear to be a
num_cycles_per_usec() function, so there's no way for me to scale the
count to a fixed time period.

-- 
Timur Tabi
Linux kernel developer at Freescale
