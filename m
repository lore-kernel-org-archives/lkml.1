Return-Path: <linux-kernel-owner+w=401wt.eu-S933562AbXLMVlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbXLMVlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764668AbXLMVlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:41:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759565AbXLMVlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:41:35 -0500
Message-ID: <4761A6CF.10307@redhat.com>
Date: Thu, 13 Dec 2007 19:40:31 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tom Spink <tspink@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, zach@vmware.com,
       roland@redhat.com
Subject: Re: [PATCH] avoid ifdefs in desc.h, getting rid of pack_ldt and pack_tss
References: <11975561713425-git-send-email-gcosta@redhat.com>	 <20071213202800.GD25130@elte.hu> <20071213205838.GA9649@elte.hu>	 <20071213212221.GA16747@elte.hu> <4761A385.1080301@zytor.com> <7b9198260712131337j6249c980q55306b676b361776@mail.gmail.com>
In-Reply-To: <7b9198260712131337j6249c980q55306b676b361776@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Spink wrote:
> On Dec 13, 2007 9:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Ingo Molnar wrote:
>>>> could we _please_ use basic tools as vmlinux size comparison and
>>>> objcompare when unifying, to make sure it's a 100% identity
>>>> conversion?
>>> case in point, the patch claims:
>>>
>>>>> No functional change is made.
>>> but vmlinux before/after size comparison shows:
>>>
>>>     text    data     bss     dec     hex filename
>>>  8802894 1224910 3526656 13554460         ced31c vmlinux.before
>>>  8803042 1224910 3526656 13554608         ced3b0 vmlinux.after
>>>
>> Well, "no functional changes" is not quite the same thing as "no object
>> code changes".
>>
>>         -hpa
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> I'm by far no expert on the subject, but after a quick eyes-debug,
> have you got the size and type parameters reversed here:
> 
> +       set_tssldt_descriptor(&tss, (unsigned long)addr,
>                IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1,
>                DESC_TSS);
> 
> Should DESC_TSS be the parameter before that big size equation?
> 
That's it. I made this mistake once, and fixed it. But I may have sent 
an older, and obviously wrong version of the patch. My fault.
