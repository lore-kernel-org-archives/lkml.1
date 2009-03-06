Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbZCFWNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbZCFWNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZCFWNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:13:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:50596 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbZCFWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:13:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BuH7OmmHv3XhWlIYVSc4D0rTHz68sst8BlPqt93bXo0RD7bwQQRqzemVlt9rcHHfNs
         XDz8Wj90Ysk4R6v5oFHQuqP2wZSDTvwkJsdp0bTh96xhhiwXIKja6j7fIvxutPTlHMrx
         TZy1Jt5zpDKJDCZfA6yu6CB2A+EIufm3KERVU=
Message-ID: <49B19FF3.2000605@gmail.com>
Date: Fri, 06 Mar 2009 23:13:07 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid/apple: add module parameter to swap the Command and
 Option keys
References: <87zlfz8bc1.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87zlfz8bc1.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.3.2009 06:33, Paul Collins wrote:
> --- a/drivers/hid/hid-apple.c
> +++ b/drivers/hid/hid-apple.c
> @@ -40,6 +40,11 @@ module_param(fnmode, uint, 0644);
>   MODULE_PARM_DESC(fnmode, "Mode of fn key on Apple keyboards (0 = disabled, "
>   		"[1] = fkeyslast, 2 = fkeysfirst)");
>
> +static unsigned int swapmodifiers = 0;

Nowadays compilers optimize this away already, but no need to initialize 
.bss stuff to zero anyway.

> +module_param(swapmodifiers, uint, 0644);
> +MODULE_PARM_DESC(fnmode, "Modifiers match labels or positions "

Weird first parameter => swapmodifiers.

Maybe this should rather be a bool instead of uint.

> +		 "([0] = labels, 1 = positions)");
> +
>   struct apple_sc {
>   	unsigned long quirks;
>   	unsigned int fn_on;
> @@ -123,6 +128,14 @@ static struct apple_key_translation apple_iso_keyboard[] = {
>   	{ }
>   };
>
> +static struct apple_key_translation apple_swap_modifiers[] = {

This might go into .rodata, right? => const

Anyway this is not feasible to do in this patch. Would you like to post 
a followup patch which will also modify the functions which use the 
translation tables?
