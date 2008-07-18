Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYGRJF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYGRJF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYGRJFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:05:43 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:10516 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbYGRJFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u+lqef3cv6xg8l5549fnUy7DywXMzDTdakM5nJzu3xa1cVvO43YOsHoXlLbIQ+zO6a
         HgGj0RKaFKaQksbs5JR0k6pq6SLv8YM7oDltpY8+VE6rOtRMLortI9hEJykookQDzZ9w
         1y8BoCK8MUEADVotftaMnnAMdAtBxNu34KJDw=
Message-ID: <aec7e5c30807180205k4aef2224ne4d0c2f7b0cd3dbb@mail.gmail.com>
Date: Fri, 18 Jul 2008 18:05:35 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [PATCH 02/05] resource: add resource_type() and IORESOURCE_TYPE_BITS
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, gregkh@suse.de,
       lethal@linux-sh.org, i2c@lm-sensors.org, akpm@linux-foundation.org
In-Reply-To: <20080718083317.GN24620@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
	 <20080718074018.32713.11976.sendpatchset@rx1.opensource.se>
	 <20080718075601.GL24620@fluff.org.uk>
	 <aec7e5c30807180124j3623675fwaeedcaf23e4b0b05@mail.gmail.com>
	 <20080718083317.GN24620@fluff.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 5:33 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Fri, Jul 18, 2008 at 05:24:59PM +0900, Magnus Damm wrote:
>> On Fri, Jul 18, 2008 at 4:56 PM, Ben Dooks <ben-linux@fluff.org> wrote:
>> > You are changing a simple test to a mask and compare, is anyone going
>> > to produce resources with an IORESOURCE_MEM and an IORESOURCE_IO
>> > together?
>>
>> Actually, I'd like to replace the one-bit-per-type strategy with a
>> N-bit counter. But that is not very compatible with the case you are
>> pointing out. I'm not sure if that's a combination we really want to
>> support though. Both IRQ and DMA doesn't make much sense to me. =)
>
> I'm not saying it is a bad idea, I just do not know if anyone is
> currently relying on this to work...

In V1 I posted both a mega patch that went through and converted arch/
and also a patch that converted the type into a N-bit counter. In V2
I've taken more of a step-by-step approach and not converted into a
N-bit counter.

I'm thinking that this patch shouldn't break anything since the bits
are left exactly like before. And the code in drivers/base/platform.c
seems to treat the bits as only one should be set anyway. For instance
platform_device_add() seems to prioritize IORESOURCE_MEM over
IORESOURCE_IO.

Or did I change the logic in drivers/base/platform without realizing it?

Cheers,

/ magnus
