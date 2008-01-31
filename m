Return-Path: <linux-kernel-owner+w=401wt.eu-S932356AbYAaTgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbYAaTgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 14:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763446AbYAaTg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 14:36:27 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:57504 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532AbYAaTg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 14:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qqp9hyK7YqHfcjoVRIXH75J1FUYUoqTLuLKI45nvd/CIiMdsktLUfe9gzQtpy1f197Ty0O/dxfJQdBPmBuoWbosC6WijbEn4AuuuS14+H3c2q7rXRRTzwjy8/QKe7sVSl9d71f7w10VeNKrpfK/VrlssULocslSAZja5UrgNINM=
Message-ID: <3efb10970801311136y12670f12x6e4fdd44de3677b9@mail.gmail.com>
Date: Thu, 31 Jan 2008 20:36:25 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Cc: michael <trimarchi@gandalf.sssup.it>, fabio@gandalf.sssup.it,
       "Andrew Victor" <linux@maxim.org.za>,
       "Chip Coldwell" <coldwell@redhat.com>,
       "Marc Pignat" <marc.pignat@hevs.ch>,
       "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129224316.GA23155@gandalf.sssup.it>
	 <479FB2D7.4020804@gandalf.sssup.it>
	 <20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	 <47A051A7.7030004@gandalf.sssup.it>
	 <20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
	 <47A09723.7020000@gandalf.sssup.it>
	 <20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
	 <47A12A2E.5040309@gandalf.sssup.it>
	 <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 3bc16c26a7233fd0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

> It seems to be very sensitive to network traffic though...could it have
> something to do with softirq scheduling? Could you try the patch below
> and see if you can trigger the error message?

Funny that you mention this.
The largest latencies I currently have on RT (and rm9200) occur when
using a telnet session or NFS filesystems, thus while using network.
The impact on hardware Interrupt latencies are limited (<85us), so the
interrupt handler should still be able to keep up the receive buffer,
but context switches between threads can stall for a longer time under
some conditions.
A long shot, but can it be that the ringbuffer overflows, and that
therefor characters are lost?


Kind Regards,

Remy
