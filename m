Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYEaSVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYEaSVH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 14:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYEaSU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:20:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:26899 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbYEaSUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kurJ3sASzL/0VoNkyAE88t48QqjV1f8EPk4bfd9xUucq8CgzOhLVnVwTzgOGPulQvqvx4Im6cQGD2eR/XzV9VTb+2nUdti/arj4xY310vU4evAza3ha8DVNHt2wgs79IyDQ629rbXyVwtxvY+qhFbarqPbCHKzmKfw4TRnHQcWo=
Message-ID: <5d96567b0805311120w516b0064h55a211c707a1dbae@mail.gmail.com>
Date: Sat, 31 May 2008 21:20:55 +0300
From: Raz <raziebe@gmail.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: mmap over HPET - 32 bit wrap arround
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <75b66ecd0805281657k7b988bf1qa46e806810da0c17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83CA05F64804AF43B8F733C4ABDFAA5101384F73@mail1.bitband.com>
	 <83CA05F64804AF43B8F733C4ABDFAA5101384FA4@mail1.bitband.com>
	 <5d96567b0805281519v7ee18eb0l27f2e4edc18af01c@mail.gmail.com>
	 <75b66ecd0805281657k7b988bf1qa46e806810da0c17@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 2:57 AM, Lee Revell <rlrevell@joe-job.com> wrote:
> On Wed, May 28, 2008 at 6:19 PM, Raz <raziebe@gmail.com> wrote:
>> I am wondering wether someone can explain how hpet behaves. The bellow
>> is a short program that reads from a mmaped /dev/hpet the time. I am
>> running it and it looks that afer ~296 seconds the counter resets . I
>> AM RUNNING  64bi KERNEL(2.6.18-8.el5)  and reading a 64BIT VARIABLE.
>> my hpet is 14MHZ, so I  am guessing a 32bit wraparound ( ~296 * 14Mhz
>> ) =  MAX_INT . but why ?
>>
>
> HPET counter can be either 32 or 64 bit.  Check COUNT_SIZE_CAP.
>
> http://www.intel.com/hardwaredesign/hpetspec_1.pdf
>
> Lee
>
Thank you Lee for your response. According to the SPEC I debugged and found:
section :2.3.4  Main Capabilities and ID Register
           bit 13: HPET_COUNTER_SIZE_MASK & readq(&hpet->hpet_cap) is on.
indicates 64bit timer.

section 2.4.8 Timer n Configuration and Capabilties Register
bit 5 on Tn_SIZE_CAP is to 32bit. Problem is that it is readonly( page
18 in spec).
None of the above counters is 64bit, and there is no BIOS settings for
hpet ( T61 Lenovo ).
Furthermore , I have 3 timers , and only a single /dev/hpet. why ?
thank you
--
Raz
