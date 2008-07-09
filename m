Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYGIURz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYGIURz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYGIURo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:17:44 -0400
Received: from gw.goop.org ([64.81.55.164]:47216 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbYGIURn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:17:43 -0400
Message-ID: <48751CD5.8080303@goop.org>
Date: Wed, 09 Jul 2008 13:17:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies
References: <patchbomb.1215554782@localhost> <20080709195218.GA9608@elte.hu> <200807092159.35288.rjw@sisk.pl> <200807092202.27013.rjw@sisk.pl> <20080709200428.GB14009@elte.hu>
In-Reply-To: <20080709200428.GB14009@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
>   
>>> This combination actually doesn't make sense whatsoever.
>>>
>>> PM_SLEEP depends (indirectly) on PM and the fact that it's possible 
>>> to use a .config violating this dependency is a build system 
>>> problem, really.
>>>       
>> Your patch is correct, though. :-)
>>     
>
> yes, that combination doesnt make sense in -git, but tip/xen64 tries the 
> !PM && PM_SLEEP combination - see the patch below. What do you think 
> about that patch?
>
> I think Jeremy's patch makes sense, but no strong feelings. We can 
> certainly map out these side-effects. (the fixes you've been Cc:-ed to 
> should be roughly all that can happen i think.)
>   

I found the PM dependencies a bit confusing.  Xen save/restore/migrate 
is functionally equivalent to some mixture HIBERNATE and SUSPEND (saving 
an image to disk is HIBERNATE, but live migration is more like 
SUSPEND).  Its implementation needs to be able to get the device model 
to do the right things - specifically the system timer devices - but has 
no other dependency on the rest of the PM infrastructure.

    J
