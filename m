Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbZHYT64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbZHYT64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZHYT6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:58:55 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52654 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZHYT6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TFq+T8xUzxJbJQltRI8xzZoV4vqWVnmQ0XVZKXOaoqphfGrNFOs2Z0L7ySLwmIRzou
         omu7l1d4AiMtcHiUdtVW/DUkxHe/MVVh6w5RNwoS+DBYIADJcIEB9umewq0lYupn2Crg
         FXr6azhvIDmFXgnHoIT1YBO+uGu4sPmzCxoII=
MIME-Version: 1.0
In-Reply-To: <4A94411E.708@goop.org>
References: <1251227779-24347-1-git-send-email-penberg@cs.helsinki.fi>
	 <4A943CBD.60808@goop.org> <1251229085.25686.2.camel@penberg-laptop>
	 <4A94411E.708@goop.org>
Date: Tue, 25 Aug 2009 22:58:55 +0300
X-Google-Sender-Auth: 0fe2754f23808e79
Message-ID: <84144f020908251258p71d5ad2fx7d31361c243a698e@mail.gmail.com>
Subject: Re: [PATCH] x86: Execute WP test after interrupts are enabled
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Brian Gerst <brgerst@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 10:53 PM, Jeremy Fitzhardinge<jeremy@goop.org> wrote:
> On 08/25/09 12:38, Pekka Enberg wrote:
>> On Tue, 2009-08-25 at 12:34 -0700, Jeremy Fitzhardinge wrote:
>>
>>> I don't think this is the real fix, and it seems a bit ugly.  I'm OK
>>> with it as a workaround, but I think it will end up getting reverted if
>>> applied.
>>>
>> Yeah, I'm fine with that. It's just that we're really late in the
>> release cycle now so I'd like to keep the fix as simple as possible.
>
> Yeah, that's fine, but I think something like this would be simpler.
> Arnd, could you test it please?
>
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Date: Tue, 25 Aug 2009 12:47:17 -0700
> Subject: [PATCH] xen: suppress WP test
>
> Xen always runs on CPUs which properly support WP enforcement in
> privileged mode, so there's no need to test for it.
>
> This also works around a crash reported by Arnd Hannemann, though
> I think its just a band-aid for that case.
>
> Reported-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 16d0d70..e5b903b 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1069,6 +1069,7 @@ asmlinkage void __init xen_start_kernel(void)
>        /* set up basic CPUID stuff */
>        cpu_detect(&new_cpu_data);
>        new_cpu_data.hard_math = 1;
> +       new_cpu_data.wp_works_ok = 1;
>        new_cpu_data.x86_capability[0] = cpuid_edx(1);
>  #endif

Yeah, this is even better assuming it works. :-)

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
