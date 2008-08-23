Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYHWBCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYHWBCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 21:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYHWBCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 21:02:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:23067 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbYHWBCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 21:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HySRdNTVIS2YyXTkszY6goHXtP5vHcBqXFmW221ZGAdMGhpUee44R+F5gOx0GyR9sh
         YxCooscZPs9oVqyWKMC05Q2NzAuAUevb/rZcojJ6k+nhANew4yx/6DRPKsHCnJW7fwl5
         QOImPHrg3t/ynDCAS83PZxQE4JsRXbIAEJDek=
Message-ID: <f17812d70808221802t250e4210y826a635d6e9688ed@mail.gmail.com>
Date: Fri, 22 Aug 2008 21:02:35 -0400
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: Fundamental Design Flaw of the Device Driver Model?
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <9e4733910808220733o7a8904do9dec947dde7d09c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
	 <9e4733910808220733o7a8904do9dec947dde7d09c0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 10:33 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On 8/22/08, Eric Miao <eric.y.miao@gmail.com> wrote:
> ======================================================
>>    This, however, creates many questions you have to face with:
>>
>>    1. on what bus shall these sub-devices be?
>>       ** this is the reason I choose to use "platform_device", at least they
>>       can reside on the platform_bus_type, thus platform_driver can be used
>>       for this sub-device
>
> Another option is making your own bus. If I understand your hardware
> it effectively has an internal bus.
>

That's another option around, but it didn't solve my fundamental question
of, (e.g. an PCI card with multiple network interfaces and other functionality):

Why should I have to create an intermediate device provided that a
"struct net_device" already contains a "struct device"? And that
device-driver binding, parameter passing (platform_data), bus and
other functionalities of this "struct net_device" is not used while
that's used solely by that intermediate device (platform_device maybe)?

They should have perfectly been combined into a single virtual device.
