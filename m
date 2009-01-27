Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbZA0IFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbZA0IFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZA0IFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:05:37 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:18638 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbZA0IFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:05:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=T4EmaoovJdoCi3qJpeKJvNNSy7T+utR5xKToOIjymWZGIgHama+dxmwEWNW2C6R6oe
         7d0ZnCpqlNwwgNtuKyzwV+ihvptpcyeUI6TRaAo2oI4PoKaKu4CbOfOFhqldEjQz2TdS
         VOYamPuc+Vy9xip0zfYNB+OzZwbF5tpO+t3jQ=
Message-ID: <497EC0A6.8020802@gmail.com>
Date: Tue, 27 Jan 2009 09:07:02 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: GTT full but LRU empty
References: <497DFC8B.9040405@gmail.com> <1233009512.4876.3.camel@gaiman>
In-Reply-To: <1233009512.4876.3.camel@gaiman>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Anholt pisze:
> On Mon, 2009-01-26 at 19:10 +0100, Jacek Luczak wrote:
>> Hi Eric,
>>
>> Are those errors known?
>>
>> [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
>> [drm:i915_gem_object_pin] *ERROR* Failure to bind:
>> -12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request empty 1
>> flushing empty 1
>> [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
>> [drm:i915_gem_object_pin] *ERROR* Failure to bind:
>> -12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request empty 1
>> flushing empty 1
>> [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
>> [drm:i915_gem_object_pin] *ERROR* Failure to bind:
>> -12<3>[drm:i915_gem_execbuffer] *ERROR* Failed to pin buffers -12
>> [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
>> [drm:i915_gem_object_pin] *ERROR* Failure to bind:
>> -12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request empty 1
>> flushing empty 1
>> [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
>> [drm:i915_gem_object_pin] *ERROR* Failure to bind:
>> -12<3>[drm:i915_gem_execbuffer] *ERROR* Failed to pin buffers -12
>>
>> They appeared once and no more, but I've changed my configuration in between
>> (switched to UXA, removed IntelFB from kernel).
> 
> Those messages occur when a client asks the kernel to exec a batchbuffer
> that the kernel can't fit into the unpinned aperture space.  Userland is
> supposed to be tracking how much space its stuff uses and flushing
> before that time, but certain bad things could break that by violating
> the assumption that the amount of pinned space doesn't change.  Our XV
> code today, for example.  I've been working on cleaning up the remaining
> bad userland bits, but it's painful work.  Luckily, other than dmesg
> spam warning that some rendering just go dropped on the floor, and some
> rendering not occurring, nothing else harmful should be happening.

Thanks Eric. So it's mostly broken userspace. Pity that I don't remember what I
was running while this error occurred.

-Jacek
