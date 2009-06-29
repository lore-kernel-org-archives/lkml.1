Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZF2IEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZF2IEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZF2IEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:04:33 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:55350 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZF2IEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vIx07IS13TpUBjort78gpjRBR6Bf/Deqtj0hOpJdiOa6satH60hPD2Ct1nUmhqfb4w
         2sdTLN4iPnWcFHW2DVNKhlvTsAekqqOq1tp4RXupleWiqMnqpjxqROrPXx/UUJ2VFy2j
         ZG1xu+wwzfLcSZkBwsNaDLTrLaKJv0OGSq/Wg=
MIME-Version: 1.0
In-Reply-To: <20090629072047.GB20225@elte.hu>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
	 <20090629072047.GB20225@elte.hu>
Date: Mon, 29 Jun 2009 16:04:35 +0800
Message-ID: <3877989d0906290104q11a767b6qcc1acc4c2d1feba6@mail.gmail.com>
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
From: Luming Yu <luming.yu@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 3:20 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Luming Yu <luming.yu@gmail.com> wrote:
>
>> Hello,
>>
>> We need to use IPI shortcut to send lapic timer broadcast
>> to avoid the latency of sending IPI one bye one on systems with many
>> logical processors when NO_HZ is disabled.
>> Without this patch,I have seen upstream kernel with RHEL 5 kernel
>> config boot hang .
>
> hm, that might be a valid optimization - but why does the lack of
> this optimization result in a hang?

It is hang caused by kernel code for work around lapic-timer-stop issue.
With HZ=1000, and a lot of cpus (eg. 64 logical cpus), cpu 0 will be
busy working on send TIMER IPI instead of making progress in boot
(right after deep-C-state has been used).




>
>        Ingo
>
