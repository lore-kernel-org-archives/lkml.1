Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYLPTaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYLPTaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYLPTaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:30:08 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:41031 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYLPTaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:30:07 -0500
Message-ID: <494801B3.9060203@nortel.com>
Date: Tue, 16 Dec 2008 13:29:55 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: ptb@inv.it.uc3m.es
CC: Andreas Schwab <schwab@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: time_is_after_jiffies misnomer
References: <200812161632.mBGGWh213629@inv.it.uc3m.es>
In-Reply-To: <200812161632.mBGGWh213629@inv.it.uc3m.es>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2008 19:29:59.0692 (UTC) FILETIME=[AF522CC0:01C95FB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter T. Breuer wrote:

> Forgive me, but you don't seem to really be taking it on board here
> either ...  what it SAYS to an english reader is the opposite of what
> you intend it to MEAN, unfortunately :(.

time_is_after_jiffies(foo) means: time "foo" is after the current value 
of the variable "jiffies" (which is used throughout the kernel as the 
current time).

You are interpreting it as: the current time is after time "foo" (which 
is in jiffies).

The reason why your interpretation is incorrect is that "jiffies" is a 
specific variable in and of itself, and not a modifier for "foo".

> So how about keeping the current macro
> names but gradually phasing them out in favour of a parallel set of 
> alternatives, which could be
> 
>     current_time_is_before_jiffies(foo)
> 
> ?? That reads fine in english and this time it means what it says!


You're using "jiffies" as a modifier for "foo", when it is actually a 
separate variable.  This makes your version just as ambiguous.

If you really want to change it, removing "jiffies" from the name (and 
thus removing any ambiguity) may make more sense.  Something like:

time_is_after(foo)

which would mean that the current value of "jiffies" is after "foo".

Chris
