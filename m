Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbYJWEUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbYJWEUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 00:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbYJWETw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 00:19:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:33677 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbYJWETv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 00:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kExX4mLYwW+Oyi/eLTfjlmTJ7onVS6+BMwrWDeomqaPqyZlzrrSE6RggzowByZamTE
         2P4S8mXIv+UTpIQjTUYfe8XD/vC4JL8wUWxFPvM84KsYJQVGjz2BSlytJXB5ZBuEXmc4
         EHDqrCjiapRTSq8KCsg4HlQ5b4L5V+owcrKc0=
Message-ID: <86802c440810222119l7f06f11bgf84cb66e5c232b8f@mail.gmail.com>
Date: Wed, 22 Oct 2008 21:19:50 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH] pci: show dma_mask bits in /sys
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20081023032833.GK26094@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org>
	 <20081009211837.GC18444@colo.lackof.org> <48EE7745.2020603@kernel.org>
	 <20081009213551.GC25780@parisc-linux.org>
	 <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com>
	 <20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org>
	 <20081012071157.GA20056@colo.lackof.org> <48FFD726.2010600@kernel.org>
	 <20081023032833.GK26094@parisc-linux.org>
X-Google-Sender-Auth: 83a6a22c12443394
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 8:28 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Oct 22, 2008 at 06:45:10PM -0700, Yinghai Lu wrote:
>> Grant prefer to add it /sys instead of showing in bootlog
>>
>> so could catch if the driver set the correct dma_mask.
>
> I still don't think this is useful information to be exposing.
>

RHEL 4.6 driver sata_mv is very run out of gart IOMMU, and need iommu
apterture to be 512M...
when loading is high, and it turns out every those card support 64bit
DMA, the driver DID NOT set dma to 64bit
so it still use 32 bit...

YH
