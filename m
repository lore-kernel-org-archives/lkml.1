Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbZAOXjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbZAOXjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZAOXjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:39:10 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:45099 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbZAOXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:39:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z2aMXN0R0dxOhGyI17oCKfIpVVg7WUfmk/Ax3A6VcPSeuUzSBU9o02WytEeRbnd+z/
         pGPbsLXdYcK7+dI6Jq25BlJHUTpapZ6PuHLb56qhBAtWPt+YPhlpQph/oP6ShTg4Hujn
         wU+5pyK2QdIIWn5+EJTE8LZtnKmOmxii6IkNQ=
MIME-Version: 1.0
In-Reply-To: <496FBF2B.4010809@linux.intel.com>
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu>
	 <49594411.60000@linux.intel.com> <20090113174522.GA26965@elte.hu>
	 <b3ece790901131057w4c76a428p4308b494675d69aa@mail.gmail.com>
	 <496DB067.6060402@linux.intel.com>
	 <b3ece790901140818i183bc30n2de01b5edaa6a2c7@mail.gmail.com>
	 <496E297B.6010100@linux.intel.com>
	 <b3ece790901141132u28ba2482h2e7af7bd51224f2a@mail.gmail.com>
	 <496FBF2B.4010809@linux.intel.com>
Date: Thu, 15 Jan 2009 15:39:07 -0800
Message-ID: <b3ece790901151539s1c470472x5255688477d54d7f@mail.gmail.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
From: Tim Hockin <thockin@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       ying.huang@intel.com, Aaron Durbin <adurbin@gmail.com>,
       priyankag@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 2:56 PM, Andi Kleen <ak@linux.intel.com> wrote:
> Tim Hockin wrote:
>>
>> Yeah, no offense, but that's horrible :)
>
> I'm not sure it's worse than the XML like format proposals that seem to
> get thrown around. That is I am the only one who mentioned the
> X word yet, but the structured ASCII records that have been hinted
> at would be exactly like that.

Yeah, if anyone proposes XML, I'll punch them :)  I'm not that firm on
it being ASCII myself, but it would be OK.  Google's protocol buffers
are a good example of a very efficient encoding of flexible data.
This is not an unsolvable problem.

>> SATA
>> disk timeouts.
>
> Now that's a different issue. Generalized driver error reporting for
> everyone.
>
> There was a lot of discussion some years ago from a IBM proposal to do
> in general structured error reporting. But that was quite unpopular
> and no-one really liked it.
>
> What came out of it was the dev_printk() stuff that allows
> to match error messages to devices. So you already have some
> baby steps in this direction.

I remember - I was at Sun at the time.  We wanted the same thing.

> I suspect doing this fully generalized would be quite difficult
> because there would be so many people you have to convince.

Yes, it will be hard.  But I think it will not be impossible.

>> Now I know there are different conduits for some events - netlink
>> tells me about netif link up/down events I think.  I would settle for
>> a small number of interfaces.  What I don't want is what we have today
>> - EVERYTHING has a different interface.  Some are poll()-able.  Some
>> have to be actively polled.  Some have to have a daemon listening or
>> else messages are dropped.
>
> Well the kernel will always have limited buffers, so the someone
> needs to listen problem will be always there.

Sure, but just having a small buffer, like mcelog, and being
poll()able goes a log way.

>> Put it this way:  Given a thousand machines, I want to gather,
>> collate, and correlate all these events.  I want to be able to produce
>> a "life story" of sorts for a machine and for a data center.  Once I
>> can do that, I can start to make predictive diagnoses more accurately,
>> and I can know how much these things actually COST us.
>
> Sure sounds nice. But frankly I don't see it happening. It would
> be just too radical a change of too much code.

We do a lot of this now, but it's far less accurate than it could be,
because we drop so many events.  And programming to all the different
interfaces is difficult and error-prone.

I'm hoping we can find a solution that makes everyone only a little bit unhappy.

Tim
