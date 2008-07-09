Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYGIS7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYGIS7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYGIS7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:59:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:35244 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYGIS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=arGk6pnsJYR9RNAIN/WTVBJuuQ5ZA07RL0o4aMtIQ9afU4BdelboJgdsGhceWJtNwg
         9wDKF9mPE7kdLV8EvOIqsa2YJ+8fMp5pqOUKreKPUUgfe1+btWs9nZphf+qFNDRQmgqK
         +1Hz/Ck0PdvCQLzBk4tziaWMzHFuqxUfclrUw=
Message-ID: <86802c440807091159l1a5da57tfec1e1c7f634ffea@mail.gmail.com>
Date: Wed, 9 Jul 2008 11:59:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080709184808.GI1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080708230837.GD1678@linux-os.sc.intel.com>
	 <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com>
	 <86802c440807081856y17eb1f1cs5647b2c2a765f429@mail.gmail.com>
	 <20080709175621.GG1678@linux-os.sc.intel.com>
	 <86802c440807091105g1dd8f8a0sa8220a1bfc65a79@mail.gmail.com>
	 <20080709184808.GI1678@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2008 at 11:48 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Wed, Jul 09, 2008 at 11:05:46AM -0700, Yinghai Lu wrote:
>> > BTW, please explain the need for your patch which has more changes, instead
>> > of my simple patch which was test booted on 3 different systems with both
>> > 32bit and 64bit kernels...
>>
>> try to reduce #ifdef CONFIG_X86_64/32, and make 32/64 at the same page.
>
> But it seem to have too many changes included in one patch.
>
> like calls to e820_register_active_regions(), remove_all_active_ranges()
> disappeared all together in this patch.. ??

old e820_end_of_ram() need to active_ranges aka early_node_map is initialized...
so if we make e820_end to get end of any type, we don't need to call
e820_register_active_regions anymore. and just letnuma code init that
later. to avoid extra operation.

should put more words in commit desc.

YH
