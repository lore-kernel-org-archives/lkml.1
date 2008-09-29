Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYI2UOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYI2UOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 16:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYI2UOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 16:14:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:31524 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYI2UOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 16:14:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LTsLH7hY4cdmCHMPI2E5IgEoKy3rYlfiCQzphkrXMLTNeYmDFjcgbJobjD719v5vaF
         QbUyNo3g0ANcGESW5dZbl3I8rDr9MHDJ+SHX/jWjyQQJdDKk3kirwS1vWaAp5qW1ilHo
         trDh7+Lk2lCSNgSBWv1wwFC5C3n/N3ElEpCBM=
Message-ID: <48E1371A.7050906@gmail.com>
Date: Mon, 29 Sep 2008 23:14:18 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net,
       lirc@bartelmus.de
Subject: Re: [RFC PATCH 0/4] Implementation of IR support using the input
 subsystem
References: <20080929155506.14559.35166.stgit@terra>
In-Reply-To: <20080929155506.14559.35166.stgit@terra>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl wrote:
> Second pass at implementing evdev support for IR. The goal of in-kernel IR is to integrate IR events into the evdev input event queue and maintain ordering of events from all input devices.
> 
> Note that user space IR device drivers can use the existing support in evdev to inject events into the input queue.
> 
> Send and receive are implemented. Received IR messages are decoded and sent to user space as input messages. Send is done via an IOCTL on the input device.
> 
> Two drivers are supplied. mceusb2 implements send and receive support for the Microsoft USB IR dongle. 
> 
> The GPT driver implements receive only support for a GPT pin - GPT is a GPIO with a timer attached.
> 
> Encoders and decoders have not been written for all protocols. Repeat is not handled for any protocol. 
> I'm looking for help. There are 15 more existing LIRC drivers.


Hi,

One thing worries me, there are bazillion of different IR protocols,
but in-kernel decode support will mean that only handful of known protocols will work.
Suppose I take an old remote which has some unknown protocol.
I want to be able to teach the system to listen to it.
But how this can be done if protocols are hard coded?

I think that it would be much better to pass raw ir codes to userspace, and
make it deal with bazillion protocols, and you can always make it auto learn too, and save
results in configuration file.

My .02 cents.

Best regards,
	Maxim Levitsky
