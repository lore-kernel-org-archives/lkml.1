Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbYDZG3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbYDZG3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 02:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYDZG2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 02:28:49 -0400
Received: from gw.goop.org ([64.81.55.164]:54652 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYDZG2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 02:28:48 -0400
Message-ID: <4812CB99.1070600@goop.org>
Date: Fri, 25 Apr 2008 23:28:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org,
       Jes Sorensen <jes@sgi.com>
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-2-git-send-email-jens.axboe@oracle.com> <20080424220157.GA26179@flint.arm.linux.org.uk> <20080425071823.GF12774@kernel.dk>
In-Reply-To: <20080425071823.GF12774@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Apr 24 2008, Russell King wrote:
>   
>> On Tue, Apr 22, 2008 at 08:50:17PM +0200, Jens Axboe wrote:
>>     
>>> +		data->csd.func(data->csd.info);
>>> +
>>> +		spin_lock(&data->lock);
>>> +		cpu_clear(cpu, data->cpumask);
>>> +		WARN_ON(data->refs == 0);
>>> +		data->refs--;
>>> +		refs = data->refs;
>>>       
>> Probably a silly question, but what does data->refs do that
>> cpus_empty(data->cpumask) wouldn't do?  (as indeed ARM presently does.)
>>     
>
> I guess it can be marginally slower for NR_CPUS > BITS_PER_LONG,
> otherwise there's absolutely no reason to have a seperate ref counter.
>   

Jes was concerned about scanning bitmasks on a 4096 CPU Altix.  I'm not 
sure its all that important, but a refcount check would definitely be 
quicker.

    J
