Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbYBMUNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbYBMUNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYBMUNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:13:41 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:41494 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYBMUNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:13:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uIgNqOKhroOi8fFtnbYqOC9D3W4azZpIqjkXRA9i3OxBXIfZKzqCcFKgfz0T7K9832q5hWLmu8dARScxoWpJlou9V2PwWI4DXbaTC59LmSUnzR/1yU9LJZ0sfG0DqrQX1BjGqawFISG1/aoZwjUmRyM1r1l7TYNNu4Vbxr6BopM=
Message-ID: <3efb10970802131213y717d0c12t151ab9c61f4e9955@mail.gmail.com>
Date: Wed, 13 Feb 2008 21:13:37 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: michael <trimarchi@gandalf.sssup.it>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>, fabio@gandalf.sssup.it,
       "Andrew Victor" <linux@maxim.org.za>,
       "Chip Coldwell" <coldwell@redhat.com>,
       "Marc Pignat" <marc.pignat@hevs.ch>,
       "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <47B2CF76.6050704@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129224316.GA23155@gandalf.sssup.it>
	 <20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
	 <47A12A2E.5040309@gandalf.sssup.it>
	 <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
	 <3efb10970801311136y12670f12x6e4fdd44de3677b9@mail.gmail.com>
	 <20080204133925.73733f5f@dhcp-252-066.norway.atmel.com>
	 <3efb10970802041144j6b4e6893j293819238b5b82e8@mail.gmail.com>
	 <47A9A5B5.3060800@gandalf.sssup.it>
	 <3efb10970802061141x5fdecefao8f617265aed7cb6f@mail.gmail.com>
	 <47B2CF76.6050704@gandalf.sssup.it>
X-Google-Sender-Auth: 176b14ebda768861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

> All works now for me with preempt-rt. The problem is using hrtimer.
> I think that hrtimer are executed with interrupts disabled so, if
> this happen when I must receive a char, i have an overrun.

No, they share the same interrupt line...
So, while the timer interrupt handler is running, the serial handler
has to wait until the timer interrupt handler has finished.
Notice that the HRT interrupt handler is quite heavy and takes a long
time to complete.

And, as I already mentioned, related to the 1 byte FIFO and a
interrupt latency of about 85us (without HRT), it is logical that you
can get an overrun at the higher serial speeds... (>=115200bps)

> The only solution was the dma support to serial device.

Or, use flow control?


Kind Regards,

Remy
