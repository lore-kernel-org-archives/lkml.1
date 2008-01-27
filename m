Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYA0A7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYA0A7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 19:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYA0A72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 19:59:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:24299 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYA0A71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 19:59:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ayjH15F6n03AzmM/G2vGnj87iCN0pw0TLpXbimLKPXYLU9I+8MIiWAzDPqEduHt9v2NSgZJ9UrtfhZLo148uZxuBUYqUnatkRQei4rmeoKazwfbXIPkXQAtM37vS1TdBiO0LHkyiv3OWlNnjd5oYIKKzVr/rAesT1yQrdjfHfGE=
Message-ID: <86802c440801261659s1102f38cr16858d350929b0e1@mail.gmail.com>
Date: Sat, 26 Jan 2008 16:59:24 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ian Campbell" <ijc@hellion.org.uk>
Subject: Re: [PATCH 3/9] x86_64: Switch to .data.compressed in arch/x86/boot/compressed/vmlinux_64.scr
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
	 <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 26, 2008 3:54 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
> This makes the file identical to vmlinux_32.scr.
>
> size shows an expected movement from .text to .data and 4 extra bytes
> of padding.
>
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/boot/compressed/vmlinux_64.lds |    8 ++++++--
>  arch/x86/boot/compressed/vmlinux_64.scr |    2 +-
>  2 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
> index 8d63b3a..fe1baf5 100644
> --- a/arch/x86/boot/compressed/vmlinux_64.lds
> +++ b/arch/x86/boot/compressed/vmlinux_64.lds
> @@ -7,11 +7,15 @@ SECTIONS
>          * address 0.
>          */
>         . = 0;
> -       .text : {
> +       .text.head : {
>                 _head = . ;
>                 *(.text.head)
>                 _ehead = . ;
> -               *(.text.compressed)
> +       }
> +       .data.compressed : {
> +               *(.data.compressed)
> +       }
> +       .text : {
>                 _text = .;      /* Text */
>                 *(.text)
>                 *(.text.*)
> diff --git a/arch/x86/boot/compressed/vmlinux_64.scr b/arch/x86/boot/compressed/vmlinux_64.scr
> index bd1429c..a549526 100644
> --- a/arch/x86/boot/compressed/vmlinux_64.scr
> +++ b/arch/x86/boot/compressed/vmlinux_64.scr
> @@ -1,6 +1,6 @@
>  SECTIONS
>  {
> -  .text.compressed : {
> +  .data.compressed : {
>         input_len = .;
>         LONG(input_data_end - input_data) input_data = .;
>         *(.data)

can you make 32 bit use .text.compressed instead ?

YH
