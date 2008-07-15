Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbYGOITm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbYGOITm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYGOIT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:19:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:52607 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbYGOITZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nzXORR2CbCcs241v8HfMvBjVOW/Szq4KlwdgCt3ZoBAhlOTW9VE65fGTrAu4+Gzs82
         gPlwdkWT2UPIojOhlczqdLxH9JkgOiQMokocAd9B39+ypn1TW1Xwr8cpchyKfiDdTGJE
         /7A1RCvv3N2x/S9E7a4vzii3Np96WILtRR7XY=
Message-ID: <aec7e5c30807150119r160a104en5780c3288d50c60d@mail.gmail.com>
Date: Tue, 15 Jul 2008 17:19:24 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 04/04] resource: add new IORESOURCE_CLK type
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
In-Reply-To: <20080711121813.acc71327.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709115428.14144.7121.sendpatchset@rx1.opensource.se>
	 <20080709115502.14144.49264.sendpatchset@rx1.opensource.se>
	 <20080711121813.acc71327.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for picking up my patches.

On Sat, Jul 12, 2008 at 4:18 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 09 Jul 2008 20:55:02 +0900 Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> This patch rearranges the values of the IORESOURCE_TYPE_BITS from
>> one bit per type to a 4-bit counter. Also, IORESOURCE_CLK is added.
>> Not sure if it is better to start counting from 0 instead of 1.
>>
>
> I don't believe this is an adequate changelog.  It contains the "what" but
> not the "why".

Yeah, sorry about that. I should have been more clear.

> Why did we switch from one-bit to four-bits?

The 4-bit encoding is there because I thought it was a waste of bits
to use one bit per type. =)

I wanted to add IORESOURCE_CLK and while at it I was playing around
with changing the code to use a 4-bit value for resource type. We may
already have spare bits available that are more suitable for new types
though.

> Why did we add IORESOURCE_CLK?

Currently we use struct resource with the types
IORESOURCE_MEM/IORESOURCE_IO and IORESOUCE_IRQ to pass I/O and
interrupt parameters to platform drivers. That works fine, but I'd
like to extend this so we also pass clock information. Basically a
string that tells the platform driver which clock that should be used
with clk_get() for a certain driver instance.

I'm sure there are other ways to do this, but I'd like to have a
generic way to pass a clock string to platform devices. Using a hard
coded string in the device driver won't do since we may have multiple
instances of drivers that need to use different clocks. Extending
struct resource seems to be the easiest way to do this IMO.

If people are happy with this idea then i'd be more than happy to fix
up and resend this patch.

/ magnus
