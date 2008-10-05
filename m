Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYJEBmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYJEBmr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 21:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYJEBmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 21:42:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:37155 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbYJEBmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 21:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=jO42bhR1wDJEDEF4IiQo+/sALcxoGdUuXVRUdjFbINdM5c9X71RgkldfWaIoy0j8y/
         DDN81q3qtBiX8mS2jrxyychCOs8ve2UAJPOVS5ELnDHzwutMOq/le0bHQzO5udK8Kz/9
         ELO4Q/zOE0sD+J1w7wl4+ZlDKeMuQekIp3SUs=
Message-ID: <86802c440810041842i4950f22h5df16b1c256a698f@mail.gmail.com>
Date: Sat, 4 Oct 2008 18:42:37 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup: print out correct type
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48E80D80.2090900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>
	 <48E80D80.2090900@zytor.com>
X-Google-Sender-Auth: 4ab9b6e495c73893
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2008 at 5:42 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
>> +++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
>> @@ -1273,12 +1273,14 @@ static int __init mtrr_cleanup(unsigned
>>                size_base = to_size_factor(size_base, &size_factor),
>>                start_base = range_state[i].base_pfn << (PAGE_SHIFT - 10);
>>                start_base = to_size_factor(start_base, &start_factor),
>> +               type = range_state[i].type;
>>                  printk(KERN_DEBUG "reg %d, base: %ld%cB, range: %ld%cB,
>> type %s\n",
>>                        i, start_base, start_factor,
>>                        size_base, size_factor,
>>                        (type == MTRR_TYPE_UNCACHABLE) ? "UC" :
>> -                           ((type == MTRR_TYPE_WRBACK) ? "WB" : "Other")
>> +                           ((type == MTRR_TYPE_WRPROT) ? "WPROT" :
>> +                            ((type == MTRR_TYPE_WRBACK) ? "WB" :
>> "Other"))
>>                        );
>
> If you're going to abbreviate, please use the standard abbreviations as
> documented in the manuals.  The abbreviation for write protect is WP.
>
ok, will use WP.

YH
