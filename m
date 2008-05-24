Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbYEXAC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbYEXAC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 20:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYEXACP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 20:02:15 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:48641 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYEXACN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 20:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cNhnHAOaaAO5NsfHU+e8CJEfQpQXMxVoTV8cPTeQ7uCYTZdExDGUoMIBm2coRGSbmMP6JJKKOWZLkVuaOPPd5VXojTyoLoW90ayW714wF4SnKbMj6YPfCGlpcqYRLz/td+1hlSdO9xMVQw6A+Dt+YLaRjl7BN0NAGNL2ppy4FcI=
Message-ID: <c384c5ea0805231702x5c37cccawcfcdb800141c2aeb@mail.gmail.com>
Date: Sat, 24 May 2008 02:02:12 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Cc: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jan Altenberg" <jan.altenberg@linutronix.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Magnus Damm" <magnus.damm@gmail.com>
In-Reply-To: <20080523224359.GA3190@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local>
	 <20080523055527.GA28963@digi.com>
	 <20080523104454.4e2af6ec@bluebox.local>
	 <20080523091009.GA22821@digi.com>
	 <20080523120308.7bec1e1c@bluebox.local>
	 <20080523105604.GA23800@digi.com>
	 <20080523135557.27fe4855@bluebox.local>
	 <c384c5ea0805231344j77f61941u229206d04c1ef948@mail.gmail.com>
	 <20080523224359.GA3190@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, May 24, 2008 at 12:43 AM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Fri, May 23, 2008 at 10:44:42PM +0200, Leon Woestenberg wrote:
>>
>> Shouldn't this be more future-proof, what if we need to abuse write()
>> for something else in the future?
>
> We don't. I'm thinking about letting the function fail if irq_on is not
> 0 or 1, just to stop any ideas of abusing write().
>
We don't want to be future-proof?

With kernel UIO and userspace driver in seperate source repositories,
expect serious API drift in the longer term. I.e. the UIO interface
must be backwards and forwards proof IMHO.

> read() and write() only deal with irq handling, all data exchange with the
> device is done through mapped memory.
>
*Currently*, read() and write() only deal with irq handling.

In the future you might want to add a second control. I cannot think
of what that should be now, much like it was not foreseen a write()
call was needed.

>> I would suggest a check for ppos to be 0 (zero) as well, just to be
>> sure and future-proof and backwards-safe.
>
> write() is only for enabling/disabling irqs, there's only one possible
> value of count, and we don't have a seek function. So why check ppos?
>
So that *if* we have a second write()able location (again, for
something I cannot foresee now), you at least check that the userspace
proper wants to enable/disable the interrupt.

AFAIK, POSIX pwrite() does not require a seek() implementation in the
driver, but will come in with a different ppos.

Idea and patch looks fine, I just wanted to bring this up so that it
is considered.

Regards,
-- 
Leon
