Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbYHKQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbYHKQpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYHKQpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:45:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39308 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYHKQpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xAEd7sK6s58AMuFxFX7obiKGeJ+MpW48we4UHvyLDJZwWRcc4pv+TP8rhjskIPf8hf
         +5cB9mt26RM8hBD0vt+pDIAz3F/JnRqTzxmXzL5aWjDf1JcFl/8r3OLoqW+zyVYK4BRs
         y/C3aDZ3veQttMMhNrnSVyY6mq2QZvPTfkYBw=
Date: Mon, 11 Aug 2008 20:45:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
Message-ID: <20080811164508.GA18969@lenovo>
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl> <48A05EB1.3050508@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A05EB1.3050508@keyaccess.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rene Herman - Mon, Aug 11, 2008 at 05:45:53PM +0200]
> On 11-08-08 17:44, Rene Herman wrote:
>
>> One problem; on 32-bit, "apic=" is a __setup() param and isn't actually 
>> early enough for us here so this needs it turned into an early_param()  
>> (followup).
>
> Ie:
>
> Rene.

| From 9655f5ab2537ecd5c5d92b03840f3b6aeed441ad Mon Sep 17 00:00:00 2001
| From: Rene Herman <rene.herman@gmail.com>
| Date: Mon, 11 Aug 2008 17:35:41 +0200
| Subject: [PATCH] x86: make "apic" an early_param() on 32-bit
| 
| On 32-bit, "apic" is a __setup() param meaning it is parsed rather
| late in the game. Make it an early_param() for apic_printk() use
| by arch/x86/kernel/mpparse.c.
| 
| On 64-bit, it already is an early_param().
| 
| Signed-off-by: Rene Herman <rene.herman@gmail.com>
| ---
|  arch/x86/kernel/apic_32.c |    4 ++--
|  1 files changed, 2 insertions(+), 2 deletions(-)
| 
| diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
| index d6c8983..f432d48 100644
| --- a/arch/x86/kernel/apic_32.c
| +++ b/arch/x86/kernel/apic_32.c
| @@ -1726,9 +1726,9 @@ static int __init apic_set_verbosity(char *str)
|  		apic_verbosity = APIC_DEBUG;
|  	else if (strcmp("verbose", str) == 0)
|  		apic_verbosity = APIC_VERBOSE;
| -	return 1;
| +	return 0;
|  }
| -__setup("apic=", apic_set_verbosity);
| +early_param("apic", apic_set_verbosity);
|  
|  static int __init lapic_insert_resource(void)
|  {
| -- 
| 1.5.5
| 

Hi Rene,

you turned it into early_param so now it's NULL injecting vulnerabled.
Could you please add checking for NULL str param?

		- Cyrill -
