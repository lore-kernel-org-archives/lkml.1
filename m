Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199Ab0ALWUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0ALWUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416Ab0ALWUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:20:23 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:52105 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0ALWUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:20:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WyyZpQo38rflwy2++PsDE+pX3JyX3SPipFCCscSt7F7GG258QWBqpw4PfTVLY1E5YK
         HyZ54XUMIUJmjLK8v7cb0aGM1U4/fRtoTKLqaOgz3essTTRyIiBMZMVWOaFoZSs7UhRm
         MQ9+RerhVtfU+jp5QcQJ/UI53ABH8FLeiAjSw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1001121426450.25925@router.home>
References: <1263298146-25597-1-git-send-email-yinghai@kernel.org>
	 <alpine.DEB.2.00.1001121331590.25925@router.home>
	 <86802c441001121157y5cdc1a91g2a66d8591d6fd579@mail.gmail.com>
	 <alpine.DEB.2.00.1001121426450.25925@router.home>
Date: Tue, 12 Jan 2010 14:20:22 -0800
X-Google-Sender-Auth: 59123ea5e7ed5caf
Message-ID: <86802c441001121420y6f585293g341a28030746a512@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] use nr_cpus= to set nr_cpu_ids early
From: Yinghai Lu <yinghai@kernel.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 12:31 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Tue, 12 Jan 2010, Yinghai Lu wrote:
>
>> > Why do we need this twice?
>>
>> maxcpus only change setup_max_cpus., and if you are using maxcpus=1,
>> and you have 8 cpus installed, you can put other
>> cpus back online via /sys/interface.
>
> Hmmm.. Strange semantics since maxcpus=0 disables smp completely. No cpu
> can be activated later. Similar to nr_cpus ?

no
for SMP kernel, when nr_cpus=1 is specified, it looks like only one
cpu is installed physically.
smp is still enabled.

maxcpus=0 is really caused misunderstanding.

other maxcpus=1 and other should be rename to boot_online_cpus=


>
>> nr_cpus= is hard limit nr_cpu_ids, so if you have 16 cpus installed,
>> nr_cpus=8 will make your nr_cpu_ids=8, and you can not put back
>> other 8 back. and apic mode could stay with logical flat.
>> this is used to simulate some debug case. for example you have kernel
>> support physflat, and flat, with CONFIG_NR_CPUS=255. to run that on
>> system that only have 8 cpus, you will have apic mode in logical flat.
>>  but if you have run the kernel on system with 32 cpus installed, it
>> will switch to physflat even you have maxcpus=8 appedded.
>
> Ok makes sense.

good.

YH
