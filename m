Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYIQIpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYIQIpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYIQIpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:45:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:13776 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYIQIpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:45:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bDH9/ybu+0wWTyTvwU0zsVVYGBRNI6+kK7s/PxxRPowm5JGcJCLSf01PDqjODzp0/e
         oaNNfJonIYFciamkWKiw0vdpBWsM92wv/nHu6YEqhCHjjQEwmhIBxY/2knvhzD18BGtn
         vzLJXTN9OLLMet9Ka1uyK058I8pRZPlZzt1lg=
Message-ID: <86802c440809170145s317e6ef8xad352e3a306abe45@mail.gmail.com>
Date: Wed, 17 Sep 2008 01:45:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 6/6] x86: add KERN_APIC
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080917083809.GB24035@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
	 <1221640067-24389-7-git-send-email-yhlu.kernel@gmail.com>
	 <20080917083809.GB24035@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 1:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> and kill apic_printk
>> using loglevel=apic:8 instead
>
> yes, that aspect is very nice.
>
>> +DEFINE_LOGLEVEL_SETUP_DEF(apic, KERN_APIC, "apic:", 6);
>
>> -             printk(KERN_WARNING "APIC calibration not consistent "
>> +             printk(KERN_WARNING KERN_APIC "APIC calibration not consistent "
>
> here too the question arises: what should the semantics of the 'mixing'
> of such subsystem printk tags with the classic priority tags be. I think
> in this particular case we dont want the KERN_APIC tag, as that would
> prevent this failure message to be printed by default. I.e. this line
> should remain:
>
>> -             printk(KERN_WARNING "APIC calibration not consistent "
>
> to make sure this warning always shows up in the logs. Agreed?

with

DEFINE_LOGLEVEL_SETUP_DEF(apic, KERN_APIC, "apic:", 6);

the KERN_WARNING <5> will be showing up that warning, even without
loglevl=apic:8

or change that  to
DEFINE_LOGLEVEL_SETUP_DEF(apic, KERN_APIC, "apic:", 7);
?

YH
