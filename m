Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbYD1Hid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbYD1Hid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763172AbYD1HiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:38:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53075 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750820AbYD1HiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:38:23 -0400
Message-ID: <48157EE9.1040907@sgi.com>
Date: Mon, 28 Apr 2008 09:38:17 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-2-git-send-email-jens.axboe@oracle.com> <20080424220157.GA26179@flint.arm.linux.org.uk> <20080425071823.GF12774@kernel.dk> <4812CB99.1070600@goop.org>
In-Reply-To: <4812CB99.1070600@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Jens Axboe wrote:
>> On Thu, Apr 24 2008, Russell King wrote:
>>> On Tue, Apr 22, 2008 at 08:50:17PM +0200, Jens Axboe wrote:
>>>> +        data->csd.func(data->csd.info);
>>>> +
>>>> +        spin_lock(&data->lock);
>>>> +        cpu_clear(cpu, data->cpumask);
>>>> +        WARN_ON(data->refs == 0);
>>>> +        data->refs--;
>>>> +        refs = data->refs;
>>>>       
>>> Probably a silly question, but what does data->refs do that
>>> cpus_empty(data->cpumask) wouldn't do?  (as indeed ARM presently does.)
>>
>> I guess it can be marginally slower for NR_CPUS > BITS_PER_LONG,
>> otherwise there's absolutely no reason to have a seperate ref counter.
> 
> Jes was concerned about scanning bitmasks on a 4096 CPU Altix.  I'm not 
> sure its all that important, but a refcount check would definitely be 
> quicker.

I just felt it was silly to do a bigger test if it wasn't necessary.
Even on a 4096 CPU box it's probably barely noticeable, but if it adds
cost then I'd be in favor of keeping the slightly faster version. Maybe
it would be worth doing a branched version, one for
NR_CPUS <= BITS_PER_LONG and one for the other case?

Cheers,
Jes

