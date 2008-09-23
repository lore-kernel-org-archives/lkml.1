Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYIWIag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYIWIag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 04:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYIWIa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 04:30:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:47192 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYIWIa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 04:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=uaLDYbhL8OeLoUJPUVHc0pDCYQ6f5pbexJ6FR/WIP2Ko4bXKOIT7qAXOaUuveYi/kq
         mTD1GOadWDMGZNfmnhWjLBI1ethrY0ogIhEh3v0VudD+nHNX6De164viYPpOJyVqR0Je
         sI8BZoMz2XHRysQji20qtWgYBqSrR+xlnKzEs=
Message-ID: <86802c440809230130n44ce9dechbe6b10ffe4685ee5@mail.gmail.com>
Date: Tue, 23 Sep 2008 01:30:26 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86: fix macro with bad_bios_dmi_table
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080923081650.GA19003@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222155333-18247-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080923081650.GA19003@elte.hu>
X-Google-Sender-Auth: 96a0e4b105a6f131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 1:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> need one blank tail.
>>
>> fix the crash on ingo's test box.
>
> applied to tip/x86/memory-corruption-check, thanks Yinghai!
>
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -760,8 +760,8 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
>>                       DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
>>               },
>>       },
>> -     {}
>>  #endif
>> +     {}
>>  };
>
> i've seen such DMI crashes numerous times, caused by a missing NULL at
> the end of the table. Is there no sane way to detect or robustly avoid
> such run-off-the-end bugs?
>
> how about changing dmi_check_system(table) to a macro, which does
> something like:
>
>   __dmi_check_system(&(table), sizeof(table))

ARRAY_SIZE()

>
> and rename dmi_check_system() in drivers/firmware/dmi_scan.c to
> __dmi_check_system() and add the size parameter? That way we could
> remove the need for NULL termination and it's even a size optimization:
> it shrinks those tables a tiny bit.

# git grep dmi_system_id | grep "\[" | wc -l
62

YH
