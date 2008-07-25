Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYGYPBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYGYPBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYGYPBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:01:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:43729 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYGYPBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dsNDVawwR1E5alpuRN/af2HVEZxsyv8JSKFPkT1wUUjn9D9qtDJ51ck7SBzDoiB+CV
         8ixOwXvogrHmjIo8GHUp9g4q2y/Uzg2/AUsu8DGLGXJuV9/opSDUDd6f+ISt0E+GvV2H
         dhVkF5OfvWPRZ16xGUObZ4ClCAXMJyM7Jzbu8=
Date: Fri, 25 Jul 2008 19:01:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take 3)
Message-ID: <20080725150104.GD28466@lenovo>
References: <20080724143151.GA32422@lenovo> <20080724150116.GC32422@lenovo> <48889C14.4070408@fujitsu-siemens.com> <4889968E.6020000@fujitsu-siemens.com> <20080725100844.GA16698@lenovo> <4889C723.7050402@fujitsu-siemens.com> <20080725125950.GA28466@lenovo> <4889D767.5050709@fujitsu-siemens.com> <20080725134831.GB28466@lenovo> <4889DCA4.4010800@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4889DCA4.4010800@fujitsu-siemens.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Martin Wilck - Fri, Jul 25, 2008 at 04:01:08PM +0200]
> Cyrill Gorcunov wrote:
>
>> Martin, if I understood you right - this means your patch is not
>> needed? 
>
> The patch would still be needed. Just the reported failure of my  
> simplified patch on the old kernel would not have occurred in the  
> current kernel. IOW, the patch is fine for the current kernel, but not  
> for the old one.
>
>> Actually on 64bit mode APIC_DIVISOR is a bit hidden in
>> __setup_APIC_LVTT - you may see it as APIC_TDR_DIV_16 while setting
>> up divisor register. I was proposing patch for that but it leaded
>> to potetntial overflow (thanks Ingo for catching) so we leave it as
>> is. Maybe I miss something?
>
> The problem was not that the divisor 16 was used for the counter speed  
> (APIC_TDR_DIV_16), but that the old code set the counter start value to  
> (250000000/16) rather than just 250000000. That means the counter will  
> underflow earlier.
>
> I am attaching a "take 3" patch which minimizes the risk of an underflow  
> by using the maximum possible initial value for the APIC timer.
>
> Martin
>

Martin, it seems you forgot to attach the patch :) (since it was
continious tense I thought I would see patch in minute but...
it was not eventually apeeared :)

		- Cyrill -
