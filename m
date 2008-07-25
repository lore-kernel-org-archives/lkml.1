Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYGYNso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYGYNso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYGYNsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:48:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:36011 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYGYNsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o500tzHsmDS7qnhzV8R0AA0ODYmKN0kM2UBRHle5ACisKuABR0+j1624v58XOcXuaf
         BQN76LBpeo1hBLyCuDk8OO8g5Ng6FRkiYtocQ4j45Z/kI767nRHKY1Zva2zLflMRUfmk
         a5SESDOLKwmHHk1CS/D5teYC3KySxrEf5JXlo=
Date: Fri, 25 Jul 2008 17:48:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take 2)
Message-ID: <20080725134831.GB28466@lenovo>
References: <20080724120512.GA21804@lenovo> <488889B6.9070707@fujitsu-siemens.com> <20080724143151.GA32422@lenovo> <20080724150116.GC32422@lenovo> <48889C14.4070408@fujitsu-siemens.com> <4889968E.6020000@fujitsu-siemens.com> <20080725100844.GA16698@lenovo> <4889C723.7050402@fujitsu-siemens.com> <20080725125950.GA28466@lenovo> <4889D767.5050709@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4889D767.5050709@fujitsu-siemens.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Martin Wilck - Fri, Jul 25, 2008 at 03:38:47PM +0200]
> I wrote:
>
>> I have to say that my simplified patch failed to do the calibration
>> correctly on our test system (the original patch worked well). Please
>> stay tuned, we are investigating this currently.
>
> Please forget that. It was observed on an old "enterprise" kernel with  
> which we are currently testing the backported patch with, and it was due  
> to the fact that the initial counter value on that kernel was divided by  
> APIC_DIVISOR (=16). The resulting initial counter value was too low in a  
> "SMI flood" case, the counter could overlap. APIC_DIVISOR is no longer  
> used in the current kernel.
>
> Martin
>
> -- 

Martin, if I understood you right - this means your patch is not
needed? Actually on 64bit mode APIC_DIVISOR is a bit hidden in
__setup_APIC_LVTT - you may see it as APIC_TDR_DIV_16 while setting
up divisor register. I was proposing patch for that but it leaded
to potetntial overflow (thanks Ingo for catching) so we leave it as
is. Maybe I miss something?

		- Cyrill -
