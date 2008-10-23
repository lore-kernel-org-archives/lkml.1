Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbYJWPdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbYJWPdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYJWPd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:33:29 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:47722 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYJWPd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mIxgIVf44ncyyr3GOj+um9RarJFem2ptz2p50ja28pR15ey3YmbA8RTrZIZpf0UR+r
         TZumoDZAGZeeTPUl/YC4pOLB5eHEXDuj81PHz6UPcX2dCbpLe9x0alXf/SFg3/d15Uye
         LWDw8kAhJ9gWG/6yckIr/B5ZwrnHQvB40dpM0=
Message-ID: <c62985530810230833j5b9dd02atae2682a7962d4476@mail.gmail.com>
Date: Thu, 23 Oct 2008 17:33:26 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: linux-next: kernel/trace/trace.c:658: error:
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0810231727430.18978@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
	 <20081023121145.GB27984@x200.localdomain>
	 <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
	 <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
	 <49008D12.5090204@gmail.com>
	 <Pine.LNX.4.64.0810231635440.18978@anakin>
	 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
	 <Pine.LNX.4.64.0810231727430.18978@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/23 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Thu, 23 Oct 2008, Frédéric Weisbecker wrote:
>> 2008/10/23 Geert Uytterhoeven <geert@linux-m68k.org>:
>> > If kernel/trace/trace.c calls irqs_disabled_flags(), it should include
>> > the include that defines irqs_disabled_flags(). You should not add it to
>> > some other random include.
>> >
>> > It's also happening on m68k:
>> > http://kisskb.ellerman.id.au/kisskb/buildresult/50641/
>>
>> The fact is that other archs include this header into their
>> asm/system.h. It seems that's because
>> they need some non-traced irq_save/restore .
>> I wanted to stay in the same approach because future use of
>> raw_local_irq could be used elsewhere
>> and seem to work perfectly whithout adding special headers on most
>> arch. But there will be some
>> bug report for each future use of these functions for alpha.... (and
>> even m68k as it seems).
>>
>> What do you think? Should I let this patch as is or send a new one
>> (and one other for m68k).
>
> kernel/trace/trace.c needs to include at least <linux/irqflags.h>, as
> that's where irqs_disabled_flags() is defined.
>
> If there are still other issues with the raw_local_irq(), IMHO they should be
> fixed separately.
>
> Hmm, what's this doing in <linux/irqflags.h>:
> | #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
> | ...
> | #endif          /* CONFIG_X86 */
>                     ^^^^^^^^^^
>

Ok, I will send a patch to correct in this way.

Thanks.
