Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYGIUXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYGIUXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYGIUXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:23:33 -0400
Received: from gw.goop.org ([64.81.55.164]:48947 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYGIUXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:23:33 -0400
Message-ID: <48751E34.3060100@goop.org>
Date: Wed, 09 Jul 2008 13:23:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies
References: <patchbomb.1215554782@localhost> <200807092202.27013.rjw@sisk.pl> <20080709200428.GB14009@elte.hu> <200807092217.53222.rjw@sisk.pl>
In-Reply-To: <200807092217.53222.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday, 9 of July 2008, Ingo Molnar wrote:
>   
>> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>>     
>>>> This combination actually doesn't make sense whatsoever.
>>>>
>>>> PM_SLEEP depends (indirectly) on PM and the fact that it's possible 
>>>> to use a .config violating this dependency is a build system 
>>>> problem, really.
>>>>         
>>> Your patch is correct, though. :-)
>>>       
>> yes, that combination doesnt make sense in -git, but tip/xen64 tries the 
>> !PM && PM_SLEEP combination - see the patch below.
>>     
>
> It shouldn't.  There are many things compiled if PM is set that PM_SLEEP
> depends on, most importantly ->suspend() and ->resume() callbacks of almost
> all drivers.  Ignoring this dependency is asking for trouble.
>   

Doesn't that mean that PM_SLEEP should depend on PM?

> I don't like this.
>
> I'll have a look at the remaining related patches and see what can be done.
>
> Jeremy, what exactly do you need the !PM && PM_SLEEP combination for, BTW?
>   

See drivers/xen/manage.c.  On the Xen save/restore path, I call 
device_(suspend|resume|power_down|power_up)(), primarily to get the 
system timers into a good state after the machine has been away for a 
while.  Xen doesn't have a general dependency on the rest of the PM 
infrastructure.

    J
