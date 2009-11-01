Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZKAXdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZKAXdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 18:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbZKAXdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 18:33:40 -0500
Received: from smtp-out.google.com ([216.239.33.17]:47655 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZKAXdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 18:33:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=yoZ2jOJOabEiPbFj0kmBeYAbWx8lQKgej/Yo9K7leVPrKyT3X4tC/4MHMurfTLw5U
	x2Kd9HmlPeXMpAKbwYVAQ==
MIME-Version: 1.0
In-Reply-To: <20091101231950.GF20740@elf.ucw.cz>
References: <20091101221345.GA16926@elf.ucw.cz>
	 <a55d774e0911011501x6abdb6a2p117f7038a4fa80cf@mail.gmail.com>
	 <20091101231950.GF20740@elf.ucw.cz>
Date: Sun, 1 Nov 2009 15:33:39 -0800
Message-ID: <a55d774e0911011533xf9b1285k7dc92745f2fb4edf@mail.gmail.com>
Subject: Re: [3/3,ARM] msm: add minimal board file for HTC Dream device
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 1, 2009 at 3:19 PM, Pavel Machek <pavel@ucw.cz> wrote:
>>
>> Pretty sure it's something later than .29
>
> I guess I should try 2.6.31.
>
>> Does enabling DEBUG_LL help?  If something's dying before the serial
>> port is registered, you might never see any console chatter.
>
> DEBUG_LL does not help. Is that early_printk() equivalent?
> With DEBUG_ICEDC I don't even get "uncompressing linux" message.

ICEDCC will try to send messages to JTAG DCC.

Sticking a call to printascii(printk_buf) after the vscnprintf() in
vprintk() in kernel/printk.c is sometimes useful alongside DEBUG_LL
(so that printks will go to the serial port immediately).

> Yes, I believe it dies before serial registration :-(. Being able to
> call puts() that decompressor uses would be useful...
>
>> Also, I believe you'll want to pass console=ttyMSM2,115200n8 on the
>> kernel commandline  (-c parameter to fastboot or mkbootimg).
>
> I'm using "console=ttyMSM2 rootdelay=5 fbcon=rotate:1" that worked for
> me on another kernel version...
>
