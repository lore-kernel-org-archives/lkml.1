Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbZFJV4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbZFJV4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZFJVzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:55:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6363 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZFJVzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:55:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=swQ+9rQ3mz+s45GjMEQ1WYFPct0TVzKDkl/YwqGT+dClj/mzYIybaghWX8WBvB6Ph
	MsATujN6bFXw13lv/2iwA==
MIME-Version: 1.0
In-Reply-To: <20090610213710.GA8472@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <20090610194852.GA28787@n2100.arm.linux.org.uk>
	 <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
	 <20090610213710.GA8472@elf.ucw.cz>
Date: Wed, 10 Jun 2009 14:55:52 -0700
Message-ID: <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 2:37 PM, Pavel Machek<pavel@ucw.cz> wrote:
>> I'd love to find an effective way to get more of the msm support
>> cleaned up (as necessary) and into the mainline.  We're bringing our
>> work forward and rebasing to keep tracking the latest released kernel,
>> and working on getting core bits we need that other stuff depends on
>> in -- look at the thread on linux-pm where the wakelock/suspendblocker
>> framework has been reviewed, revised, resent repeatedly, etc.
>
> I guess wakelocks should be removed from first version of drivers for merge.

It'd be nice to get that sorted out first, but it does seem like it's
going to take a while to get there, so yeah, guess we'd have to go a
step at a time.

>> The msm7k unfortunately requires a lot of infrastructure to work given
>> that the baseband (a black box to us) controls much of the world.
>> Last time around when I tried submitting some of the core ipc support
>> to talk to it on the lakml, there seemed to be uncertainty about who
>> even would review that.
>
> Try again, then :-). [Merging to drivers/staging is _very_ easy, and
> even that is good first step.]

Is there something equivalent for arch code?  The bulk of our msm7k
support is under arch/arm/mach-msm/... though if there are sane places
to split out bigger chunks like the qdsp5/qdsp6 support, etc, we're
open to suggestion.

I'm not sure the smd (shared memory driver / virtual serial channels)
that everything else depends on makes sense outside of mach-msm, given
it's all very specific to the baseband and firmware that runs on it.
Basically there's a stack:

smsm  -- "shared memory state machine" (used for power collapse coordination)
smd -- "shared memory driver" (virtual serial channels, 8k bidirectional fifos)
rpcrouter/oncrpc -- rpc transport layer used for audio, audio routing, etc

These are linux implementations of protocols the baseband speaks.

Other stuff then stacks on smd (rmnet -- virtual ethernet, at control
channels, etc) and oncrpc (dsp control, rtc, gps, some media control).

> Actually, mailing patches so that people do not have to do git pull +
> diff is very good zeroth step :-).

We've tried to do both in the past -- setup a patchset that's pullable
for those who want to pull and get send-email 'em out to the list.

>> We have full support for MSM7201A, including fully functional power
>> management, working on a number of commercially shipping devices that
>> we'd absolutely love to get into mainline.  Rebasing and bringing this
>> stuff forward all the time is a lot of work and certainly not the
>> optimal way to do it.  Getting it in a couple pieces at a time is slow
>> going, but it seemed to cause frustration with just the small number
>> of things we were looking for review/approval for...
>
> I have some experience with patch merging, lets see if I can
> help... It would be good to merge it upstream before the hw is
> obsolete...

Conveniently a lot of the peripherals are used in later generation 7k
and 8k SoCs, so this stuff should actually be useful for new hardware
for a while.  7201A based products are still shipping new this year
(HTC Magic, for example).

Help is certainly appreciated.

I think we're probably due for another round of flattening and
cleaning up against 2.6.30 or 31 and seeing what survives review and
what we can do to get the mainline msm code closer to fully
functional.

Brian
