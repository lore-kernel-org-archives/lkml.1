Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbYELEPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbYELEPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYELEPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:15:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:5478 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYELEPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d4nVb6nJI5QWjljoBxcX8C+MKNrUOWXWXnzzi0UMzaRNbeRAYuHYZlsUunkljuc3Qb40R4qId96aUPBhonT6tCZxCzaCh3TRxPCp7OMWnkXGMaCYmnAI8kf5CYGsvKNwZOjqkeJuRis4pZ/fy7Or/JQqd0OGY1RNAizL0e8QAp8=
Message-ID: <aa79d98a0805112115s7879d4e8q2fc97512e35fc1c8@mail.gmail.com>
Date: Mon, 12 May 2008 08:15:28 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before `.text'
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>, "Pavel Machek" <pavel@ucw.cz>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <200805112322.53473.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18470.787.498329.144701@harpo.it.uu.se>
	 <48273A32.5020104@zytor.com> <20080511182905.GD6942@cvg>
	 <200805112322.53473.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 1:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, 11 of May 2008, Cyrill Gorcunov wrote:
>> [H. Peter Anvin - Sun, May 11, 2008 at 11:25:54AM -0700]
>> > Cyrill Gorcunov wrote:
>> >> Hi Peter,
>> >> actually I only doubt about exactly position of this headers - I mean
>> >> meguess it better should be _before_ "_end" not after. Since the others
>> >> script uses (acpi/wakeup_rm.S):
>> >>    wakeup_code_start:
>> >>    .incbin "arch/x86/kernel/acpi/realmode/wakeup.bin"
>> >>    wakeup_code_end:
>> >> and kernel uses these wakeup_code_* marks to save/restore memory I think
>> >> it should be like
>> >>    . = HEADER_OFFSET;
>> >>    .header : {
>> >>            ...
>> >>    }
>> >>    . = ALIGN(16);
>> >>    _end = .;
>> >>    /DISCARD/ ...
>> >
>> > Yes, I believe that's correct.
>> >
>> >     -hpa
>> >
>>
>> Thanks for review, Peter, I'll cook a patch and wait for
>> Pavel's opinion ;-)
>
> I've tested the appended one.  If that's what you mean, we'll ask Ingo to take
> it.
>
> Thanks,
> Rafael
>
>
> ---
>  arch/x86/kernel/acpi/realmode/wakeup.lds.S |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> Index: linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> +++ linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> @@ -12,11 +12,6 @@ ENTRY(_start)
>
>  SECTIONS
>  {
> -       . = HEADER_OFFSET;
> -       .header : {
> -                *(.header)
> -       }
> -
>        . = 0;
>        .text : {
>                 *(.text*)
> @@ -50,6 +45,11 @@ SECTIONS
>                __bss_end = .;
>        }
>
> +       . = HEADER_OFFSET;
> +       .header : {
> +                *(.header)
> +       }
> +
>        . = ALIGN(16);
>        _end = .;
>
>

Thanks Rafael,

it's exactly what I meant - http://lkml.org/lkml/2008/5/11/120 ;)
