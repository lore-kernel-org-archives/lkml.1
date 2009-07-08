Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZGHRld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZGHRld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZGHRl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:41:26 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:40248 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZGHRlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HK5Hl5xzrzCa19YJnQzEJOe0erjkrCjTa5qzWnsB9zQIdueOcEHrXBAlbpMzw6taHX
         jQM5GGaZ3CmagOhu9GEhEwDQ47hGwLgu6qWnKqbT3Fk6Dty0zGwkxAvfFkvE3M5SOELs
         OZd+x6BMb35Rjsl7tGj1/H195GIzf0/sfq3v8=
MIME-Version: 1.0
In-Reply-To: <20090708161052.GA20951@srcf.ucam.org>
References: <200907081556.34682.czoccolo@gmail.com>
	 <20090708161052.GA20951@srcf.ucam.org>
Date: Wed, 8 Jul 2009 19:41:23 +0200
Message-ID: <4e5e476b0907081041g5561a8b2s1bc393809a09b78b@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Introduces stepped frequency increase
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Wed, Jul 8, 2009 at 6:10 PM, Matthew Garrett<mjg@redhat.com> wrote:
> On Wed, Jul 08, 2009 at 03:56:33PM +0200, Corrado Zoccolo wrote:
>> The patch introduces a new sysfs tunable cpufreq/ondemand/freq_step,
>> as found in conservative governor, to chose the frequency increase step,
>> expressed as percentage (default = 100 is previous behaviour).
>>
>> This allows fine tuning powersaving on mobile CPUs, since smaller steps will allow to:
>> * absorb punctual load spikes
>> * stabilize at the needed frequency, without passing for more power consuming states, and
>
> Is this a measured powersaving? The ondemand model is based on the
> assumption that the idle state is disproportionately lower in power than
> any running state, and therefore it's more sensible to run flat out for
> short periods of time than run at half speed for longer. Is this
> inherently flawed, or is it an artifact of differences in your processor
> design?

The flawed assumption is that running at doubled frequency halves the
completion time.
On cpus that can change the core speed without impacting the
memory-cache bandwidth
(i.e. the Pentium M), workloads that access lot of memory go at the
same speed at
maximum and minimum frequency.
Now I see new CPUs that can flush their cache during deep idle states (Atoms),
this aggravates the aforementioned problem, rendering the high
frequency state much less appetible.

Corrado

>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
