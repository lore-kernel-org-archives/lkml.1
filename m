Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYJPHTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYJPHTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 03:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYJPHTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 03:19:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33154 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYJPHTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 03:19:11 -0400
Message-ID: <57053.192.168.10.88.1224140719.squirrel@dbdmail.itg.ti.com>
In-Reply-To: <20081014145534.GA22732@2ka.mipt.ru>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF0@dbde02.ent.ti.com>
    <20081010133845.8b82fac3.akpm@linux-foundation.org>
    <062801c92d37$3413bdd0$LocalHost@wipultra1303>
    <20081013085323.f8bd7efb.akpm@linux-foundation.org>
    <015c01c92dda$1b754340$LocalHost@wipultra1303>
    <20081014055002.24ff586a.akpm@linux-foundation.org>
    <20081014134249.GA5611@2ka.mipt.ru>
    <20081014073058.e5d972e6.akpm@linux-foundation.org>
    <20081014145534.GA22732@2ka.mipt.ru>
Date: Thu, 16 Oct 2008 12:35:19 +0530 (IST)
Subject: Re: [PATCH 1/5] HDQ Driver for OMAP2430/3430
From: "Madhusudhan Chikkature" <madhu.cr@ti.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, gadiyar@ti.com,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 14, 2008 at 07:30:58AM -0700, Andrew Morton
> (akpm@linux-foundation.org) wrote:
>> > Why not just skipping the waiting and returning error pretending user
>> > really sent a signal?
>>
>> Better than nothing, but because signal_pending() isn't actually true,
>> upper layers wil behave differently.
>
> If they check...
>
> For example omap_hdq_break() can be interrupted and omap_hdq_probe()
> does not check its return value.
>
> --
> 	Evgeniy Polyakov
>
>

Yes. I got the point. But the omap_hdq_break is not significant for HDQ. It
just resets the slave and in HDQ mode no response is expected. So the driver
will still work even if omap_hdq_break fails. On the TX path it is important to
check for the failure which was missing. I will add that check.

On the other note, let me correct myself that catching the signal on that very
small wait in TX path may not be desired by the driver. The ISR wakes it up as
expected. I intend to use "wait_event_timeout" instead and exit in the error
path if timeout elapsed.

I will repost the whole series after fixing the comments provided by Andrew.

Thanks,
Madhu


