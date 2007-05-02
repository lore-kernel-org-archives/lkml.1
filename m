Return-Path: <linux-kernel-owner+w=401wt.eu-S2993177AbXEBNjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993177AbXEBNjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 09:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993181AbXEBNjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 09:39:13 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:25380 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993177AbXEBNjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 09:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=DJTeUECXWR+rPRFFPAYyjA+BpC+0FEiM4jYFfJETeorrsyjAyqF7b6w0ljnphU66JwAKt7CManQ1spZdg3ySixShb/PSjwtypxyJsFjVBjyLEc8dB4xGIaptEpG2PIH34/fTEQnuQAsrWNe8U+/Af9t62v87BpRi48RyKTRag8Y=
Date: Wed, 2 May 2007 16:39:06 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <136343903.20070502163906@gmail.com>
To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
CC: ian <spyro@f2s.com>, kernel-discuss@handhelds.org,
       <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [Kernel-discuss] Re: [RFC, PATCH 0/4] SoC base drivers
In-Reply-To: <4637AE6D.4090408@gmail.com>
References: <1354376306.20070501080806@gmail.com>  <46374645.2030900@gmail.com> <1068016897.20070501173657@gmail.com>  <46376AD9.3020701@gmail.com> <1178042924.15769.5.camel@wirenth> <46379027.7050202@gmail.com> <281618366.20070501230902@gmail.com> <4637AE6D.4090408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

Wednesday, May 2, 2007, 12:17:33 AM, you wrote:

> Hello Paul,

> Paul Sokolovsky wrote:
>>> ASIC-related code (I mean core) forms additional platform layer, so I
>>> suggest
>>> adding ASIC helpers to generic platform code i.e. drivers/platform.c, but
>>> ASIC drivers to drivers/asic/ directory.
>>
>>         There problem here is the same - our target chips are not
>> just ASICs. 

> You say they are chips so they are integrated circuits (ICs), they
> are designed to solve some specific needs, so they are
> application-specific ICs, i.e. ASICs, what's the problem?

        The issue is that in this case functional organization what's
important, not thing like (original) design purpose/method, expressed in
vague terms like ASIC. A "passive" (from CPU point of view) chip of
30-50 gates dealing with clock/control signals destribution is of
course ASIC too, but has nothing to do with chips in question.

>> It just happens that the one we start with called such,
>> but we have different ones too. 

> Interesting what are they?
> Power management ICs? Power management + audio
> + touchscreen + ADC + USB transceiver + UART + whatever
> all such chips may be considered as ASICs.

        "May" is a keyword here. They may be considered SoCs too, as
they share one important trait with them: multiple devices of
different functions in one package. I'd of course love idea of calling
any chip but CPU and memory an ASIC, but that doesn't correspond with
reality. As an example, ICH, etc chipsets are of course ASICs, but I
personally never heard them called such, and I'm sure few listeners
would be confused, if someone called them such.

>> It's still important that they contain
>> blocks with different functionality, and drivers we propose deal with
>> basic, common functionality of chips. 

> That different functionality blocks will be handled by appropriate
> device drivers, and in general the drivers should not depend on
> a particular ASIC but use common ASIC API.
> But "common functionality" drivers are ASIC-specific.

>> Now that it was pointed out that
>> there's place in the tree for such drivers, it would be not wise to
>> try to create another one.
>>
>>
>>

> Perhaps, so.  Actually, MFD  (multi functional device) doesn't
> imply a platform-level device but ASIC seems does.

        That's also a subject of interpretation for specific
chip/driver. Proposed soc-core is actually a helper, not a strict API
to follow. We just found that many our drivers do common things, so
factored out functionality for easier reuse. It of course can be
extended given the need (but yes, so far all our MFD chips and their
subdevices are treated as platform devices).


        But back from ontology to specific ideas of patch
restructuring. Given a need to distinguish discussed chips' handling
model from "generic" MFDs (like ones already in drivers/mfd/), and the
fact that Ian Molton, author of soc-core.*, likes ASIC designator, this
warrants rename of it to asic-core.*, I guess. All it still goes to
drivers/mfd/ to not create more stuff than needed.

        As for driver headers, they apparently go to include/linux/ .
That's of course keeps being out of hand, but small guy's way to
a solution is apparently to accelerate that. When number of files in
include/linux/ will hit 1K, I guess core maintainers will notice
that something's wrong and find a global solution. (One good idea is to
separate driver-specific headers from global and subsystem ones, but
all that is out of scope for this discussion...).



> Thanks,
> Dmitry




-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

