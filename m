Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYHZKCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYHZKCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYHZKCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:02:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:42527 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYHZKCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WMf2GD1D7yI9uX5P/B4/5tmVf6r+UrkqwEqEg9RE5h6JO2PeeJksr8PHIXSxtzuAK1
         e8uBa/AADQH7pw0jC71tmzH9l0/FFxkOQJyYO05MZqMFBolwQ1ielUXiARggrqIRCb4x
         QDmvd3iAjwKRpus5tm6M/Q4mMjry5DahuDB4I=
Message-ID: <b647ffbd0808260302r1d50dbacr3595d160e0203ce3@mail.gmail.com>
Date: Tue, 26 Aug 2008 12:02:40 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "james toy" <unk.nown@unix.net>
Subject: Re: [-mmotm] BUG: scheduling while atomic: swapper
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Ryan Hope" <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <9f8af95f0808260225u162da49aj1d6f6fd9db79499f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
	 <b647ffbd0808260111r2aed706cvc4c5d483912ec8c2@mail.gmail.com>
	 <20080826012458.abe3bbba.akpm@linux-foundation.org>
	 <9f8af95f0808260225u162da49aj1d6f6fd9db79499f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/26 james toy <unk.nown@unix.net>:
> Andrew,
>
> Yes, ours does look like this -- however when i checked the git diff on git
> web i found:
>
> index d2d9d74..6dd8907 100644 (file)
> --- a/arch/x86/kernel/microcode_intel.c
> +++ b/arch/x86/kernel/microcode_intel.c
> @@ -531,12 +531,14 @@ static struct microcode_ops microcode_intel_ops = {
>
>  static int __init microcode_intel_module_init(void)
>  {
> -       struct cpuinfo_x86 *c = &cpu_data(get_cpu());
> +       struct cpuinfo_x86 *c = &cpu_data(0);

(err... I'm a bit confused by the use of "fixed" here. The snippet
posted by Andrew illustrates how it was _before_ the fix,
i.e. it's the version that causes the "scheduling while atomic" bug).

IOW, If your local version has cpu_data(get_cpu()) in
microcode_intel_module_init(), then it explains the trace you have
observed. That also means you are not up-to-date with -next.


-- 
Best regards,
Dmitry Adamushko
