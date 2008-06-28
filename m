Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYF1HnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYF1HnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 03:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYF1Hmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 03:42:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:40548 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbYF1Hmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 03:42:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IP4ev4RjkHfK8O0tpZDEjii9FPPg1zJcIUpzxxkk+9bxFetagbYtGYyGpHOV0lsxNb
         FXYDfrUelCgmuaTyL70w9qm7aRyN1V65yJITSi6YrZDc5Mi4bsN7yYfw3AbvmnaBNp5w
         o2tLO24DGLm8LZn7qj3d1eQUr7ENuMfRfjXls=
Message-ID: <86802c440806280042u72c8b55cr44fe887c28cbea70@mail.gmail.com>
Date: Sat, 28 Jun 2008 00:42:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix init_memory_mapping over boundary v2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080628072159.GA21277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806251748.06743.yhlu.kernel@gmail.com>
	 <200806252151.29028.yhlu.kernel@gmail.com>
	 <200806271538.46829.yhlu.kernel@gmail.com>
	 <200806272247.11971.yhlu.kernel@gmail.com>
	 <20080628063500.GA15710@elte.hu> <20080628070243.GA31342@elte.hu>
	 <86802c440806280019p621dee5fh8195e762e29cadc8@mail.gmail.com>
	 <20080628072159.GA21277@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 12:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> On Sat, Jun 28, 2008 at 12:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> >> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >>
>> >> > some end boundary is only page alignment, instead of 2M alignment, so
>> >> > call ker_phycial_mapping_init three times. then don't overmap above
>> >> > the max_low_pfn
>> >>
>> >> applied to tip/x86/unify-setup, thanks Yinghai.
>> >
>> > -tip testing found a 32-bit spontaneous reboot during bootup, with this
>> > config:
>> >
>> >  http://redhat.com/~mingo/misc/config-Sat_Jun_28_08_43_52_CEST_2008.bad
>> >
>> > no serial log produced at all.
>> >
>> > doing the reverts below fixes the problem.
>> >
>> >        Ingo
>> >
>> > commit 4ae56755fa1e1bd1500c97b5bf82d6519a261ffd
>> > Author: Ingo Molnar <mingo@elte.hu>
>> > Date:   Sat Jun 28 08:59:44 2008 +0200
>> >
>> >    Revert "x86: let setup_arch call init_apic_mappings for 32bit"
>> >
>> >    This reverts commit 7fce3bb20100e5b6c42ad66c495e6348522bfd37.
>> >
>> > commit 2703b959fc588f1b77290272f60bcf0bd8f6e557
>> > Author: Ingo Molnar <mingo@elte.hu>
>> > Date:   Sat Jun 28 08:59:39 2008 +0200
>> >
>> >    Revert "x86: fix init_memory_mapping over boundary v2"
>> >
>> >    This reverts commit 7a41ed2c98f860da38a944d8de5b29e6ec39cf76.
>> >
>> the system with 512M ?
>
> no, other 32-bit testsystems: 1GB RAM, 2GB RAM, etc.

good, i duplicate that one server with your config.

YH
