Return-Path: <linux-kernel-owner+w=401wt.eu-S1763282AbZE1P6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763282AbZE1P6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZE1P6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:58:35 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:60131 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZE1P6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:58:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WroaLdkTRHhV3o9VBxyZh7JJnXzqMjsViGjX8TxVy2BaaTZkd9UphwteCPPtTKtCuF
         hAdLgamfOZHTV6eFduzpXlBFjWHtTYdKZ/EME52cedhnrRajrs54yYN3wRVtkII9oFWJ
         zkdhMaMEKI3VsYa0B1pQucOhYdbTcxJD7M6NY=
Subject: Re: [RFC PATCH 0/4] V3 - Implementation of IR support using the
 input subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net
In-Reply-To: <1243523201.5254.59.camel@maxim-laptop>
References: <20081006194032.15992.8393.stgit@terra>
	 <1243523201.5254.59.camel@maxim-laptop>
Content-Type: text/plain
Date: Thu, 28 May 2009 18:58:31 +0300
Message-Id: <1243526311.5254.61.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 18:06 +0300, Maxim Levitsky wrote:
> On Mon, 2008-10-06 at 15:43 -0400, Jon Smirl wrote:
> > Third pass at implementing evdev support for IR. The goal of in-kernel IR is to integrate IR events into the evdev input event queue and maintain ordering of events from all input devices.
> > 
> > New feature, raw mode. There are three sysfs attributes - ir_raw, ir_carrier, ir_xmitter. Read from ir_raw to get the raw timing data from the IR device. Set carrier and active xmitters and then copy raw data to ir_raw to send. These attributes may be better on a debug switch. You would use raw mode when decoding a new protocol. After you figure out the new protocol, write an in-kernel encoder/decoder for it.
> > 
> > What should the IR API look like? 
> > 
> > How are IR events mapped into keyboard events? Should they be mapped? Map them in the kernel or in user space? The maps are tiny, less than 1K per remote.  Sysfs can be used to load maps into the kernel driver. Make maps only for the common buttons and don't map unusual ones?
> > 
> > How should multiple remotes be handled? Split them out into individual input devices, or group them onto a single IR device? I can implement either.
> > 
> > The in-kernel code is tiny, about 20K including a driver.
> > 
> > >From last post...
> > Note that user space IR device drivers can use the existing support in evdev to inject events into the input queue.
> > 
> > Send and receive are implemented. Received IR messages are decoded and sent to user space as input messages. Send is done via an IOCTL on the input device.
> > 
> > Two drivers are supplied. mceusb2 implements send and receive support for the Microsoft USB IR dongle.
> > 
> > The GPT driver implements receive only support for a GPT pin - GPT is a GPIO with a timer attached.
> > 
> > Code is only lightly tested. Encoders and decoders have not been written for all protocols. 
> > Repeat is not handled for any protocol.
> > I'm looking for help. There are 15 more existing LIRC drivers.
> 
> Any update on that?
> 
> I have a suggestion:
> 
> 
> Instead of decoding protocols in kernel, why not to allow userspace to
> upload timing signatures as specified in lirc.conf ?
> 
> As a example, what protocol this is:
> 
> http://lirc.sourceforge.net/remotes/toshiba/CT-9922

Replying to myself... this is NEC protocol, and this config file isn't
correct (since it was auto generated)
> 
> Best regards,
> 	Maxim Levitsky
> 

