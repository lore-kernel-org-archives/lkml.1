Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZJLOkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZJLOkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932291AbZJLOkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:40:15 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:42030 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbZJLOkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OUNwH/cHeW648+8niLBHTekiQtGIUqiNtl8Bi7GWLLD89WDp3UoVm/l+NdT3LhccPK
         qnTYulQY+PVN+lKkhenA6QOqi4Av2Pn3RET/U91DUyuoSmkXYMublz5eITtd6Dw9Lsqo
         FZArSkaOVOfDSxnY5DMuNtTecPuJnsA1R7UIA=
MIME-Version: 1.0
In-Reply-To: <20091012142940.GB1114@suse.de>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> 
	<20091012074221.GA19198@elte.hu> <8bd0f97a0910120605q17a586dag29cf4ab6d89dd29d@mail.gmail.com> 
	<20091012142940.GB1114@suse.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 12 Oct 2009 10:39:15 -0400
Message-ID: <8bd0f97a0910120739k3122bctb46713881eaef9ca@mail.gmail.com>
Subject: Re: [origin tree build failure] [PATCH] Revert "USB: musb: make 
	HAVE_CLK support optional"
To: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:29, Greg KH wrote:
> On Mon, Oct 12, 2009 at 09:05:57AM -0400, Mike Frysinger wrote:
>> On Mon, Oct 12, 2009 at 03:42, Ingo Molnar wrote:
>> >
>> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> >
>> >> As usual, please test this for regressions, both new and old.
>> >
>> >>       USB: musb: make HAVE_CLK support optional
>> >
>> > This USB/Blackfin commit broke the x86 build with these config options:
>> >
>> >  CONFIG_USB_MUSB_HDRC=y
>> >  CONFIG_USB_MUSB_HOST=y
>> >  # CONFIG_USB_MUSB_PERIPHERAL is not set
>> >  # CONFIG_USB_MUSB_OTG is not set
>> >  # CONFIG_USB_GADGET_MUSB_HDRC is not set
>> >  CONFIG_USB_MUSB_HDRC_HCD=y
>> >  CONFIG_MUSB_PIO_ONLY=y
>> >  CONFIG_USB_MUSB_DEBUG=y
>> >
>> > Because a side-effect of the patch was that it enabled the driver on x86
>> > too which doesnt have HAVE_CLK. So this formerly embedded-only driver
>> > got exposed on the more widely tested x86 platform.
>>
>> this is dumb.  you're addressing unrealistic scenarios (randconfig) by
>> reverting code for realistic scenarios.  how about updating the
>> already present arch depend string instead.
>
> We want 'randconfig' to work, so this is not unrealistic.  Have you not
> seen Randy Dunlap's zillion patches to get this to all work properly
> over the past months?

i'm not suggesting it not be fixed, i'm suggested it be *fixed*
instead of blindly reverted.
-mike
