Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbZCQRCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbZCQRCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 13:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZCQRCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 13:02:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:33983 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZCQRCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 13:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EZQbcPDxYrEc/5e5NFfsf1Icz8kWFMWrglBVAXzo3D5njEHS8sNLxz7e4mcLfCian6
         mVpz5/gHm2j4LNItfMBdSgQG0O/2webxN07aqgM4dcCcfaWoQEm42yB14JHHO+/8VG5s
         GdG9m6jhZ4SGw6SxRT+QbZiu++tiTTnsFgs6U=
MIME-Version: 1.0
In-Reply-To: <20090318.010939.128619068.anemo@mba.ocn.ne.jp>
References: <1237240246.27945.6.camel@dwillia2-linux.ch.intel.com>
	 <20090317.112019.147212126.nemoto@toshiba-tops.co.jp>
	 <e9c3a7c20903162152w6b73b4b8hba8004e7b349c447@mail.gmail.com>
	 <20090318.010939.128619068.anemo@mba.ocn.ne.jp>
Date: Tue, 17 Mar 2009 10:02:14 -0700
X-Google-Sender-Auth: a990513ae9a75193
Message-ID: <e9c3a7c20903171002n50964148v8366fa2f00e3164c@mail.gmail.com>
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 9:09 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Mon, 16 Mar 2009 21:52:10 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
>> > Hmm.. why idr_ref is dynamically allocated?  Just putting it in
>> > dma_device makes thing more simple, no?
>>
>> The sysfs device has a longer lifetime than dma_device.  See commit
>> 41d5e59c [1].
>
> The sysfs device for dma_chan (dma_chan_dev) has a shorter lifetime
> than dma_device, doesn't it?

No,  dma_async_device_unregister(), and the freeing of dma_device, may
finish before chan_dev_release is called.  Userspace gates the final
release of dma_chan_dev objects.
