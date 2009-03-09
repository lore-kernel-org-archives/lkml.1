Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZCIUsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZCIUsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbZCIUr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:47:56 -0400
Received: from gw.goop.org ([64.81.55.164]:43494 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZCIUrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:47:55 -0400
Message-ID: <49B58076.8020703@goop.org>
Date: Mon, 09 Mar 2009 13:47:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add function spin_event_timeout()
References: <1236384801-10305-1-git-send-email-timur@freescale.com>	 <adaiqmmf87v.fsf@cisco.com> <ed82fe3e0903061725y40dc246ehd3482690ee3898fa@mail.gmail.com>
In-Reply-To: <ed82fe3e0903061725y40dc246ehd3482690ee3898fa@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> On Fri, Mar 6, 2009 at 7:11 PM, Roland Dreier <rdreier@cisco.com> wrote:
>   
>>  > The function spin_event_timeout() takes a condition and timeout value
>>  > (in jiffies) as parameters.  It spins until either the condition is true
>>  > or the timeout expires.  It returns non-zero if the condition is true,
>>  > zero otherwise.
>>
>> What's the motivation for this?  Where do you plan to use it?
>>     
>
> I expect it would be useful for drivers that need to wait until a
> specific register has changed its value, but don't want to risk an
> infinite loop if the hardware is not functioning.  For example, to
> replace the while loop and subsequent check in this code:
>   

A jiffy is a really long time to be spinning, let alone liffies plural.  
In this use case are you expecting that the loop will iterate a very 
small number of times before returning, and the timeout case is a very 
unlikely error condition?

    J
