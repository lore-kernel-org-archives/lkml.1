Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949Ab0ALT5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0ALT5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844Ab0ALT5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:57:40 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:40520 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0ALT5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:57:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=RbCIVFdBG5FS1Y0ugNTzx5M7NNNJKdWTT/eI6xyKHA2Zyzwi4cNXZQsmdwQV87uRbE
         5CQlK2bMD7XcDsa0f5qkb8UVuoILEYgqr47G5iWMtEmolT6luoIfNq0jXqlx9+sFpEwJ
         Pf4EAbmBhjLHLqOHt+OvTb67MB4JHuFIvScPY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1001121331590.25925@router.home>
References: <1263298146-25597-1-git-send-email-yinghai@kernel.org>
	 <alpine.DEB.2.00.1001121331590.25925@router.home>
Date: Tue, 12 Jan 2010 11:57:38 -0800
X-Google-Sender-Auth: 40138f8210f291d0
Message-ID: <86802c441001121157y5cdc1a91g2a66d8591d6fd579@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] use nr_cpus= to set nr_cpu_ids early
From: Yinghai Lu <yinghai@kernel.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 11:32 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
>
> On Tue, 12 Jan 2010, Yinghai Lu wrote:
>
>> on x86, before prefill_possible_map(), nr_cpu_ids will be NR_CPUS aka CONFIG_NR_CPUS
>>
>> add nr_cpus= to set nr_cpu_ids. so we can simulate cpus <=8 on normal config.
>> instead of change NR_CPUS directly.
>
> We already have
>
> maxcpus=x?
>
> Why do we need this twice?

maxcpus only change setup_max_cpus., and if you are using maxcpus=1,
and you have 8 cpus installed, you can put other
cpus back online via /sys/interface.

nr_cpus= is hard limit nr_cpu_ids, so if you have 16 cpus installed,
nr_cpus=8 will make your nr_cpu_ids=8, and you can not put back
other 8 back. and apic mode could stay with logical flat.
this is used to simulate some debug case. for example you have kernel
support physflat, and flat, with CONFIG_NR_CPUS=255. to run that on
system that only have 8 cpus, you will have apic mode in logical flat.
 but if you have run the kernel on system with 32 cpus installed, it
will switch to physflat even you have maxcpus=8 appedded.

YH
