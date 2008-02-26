Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbYBZHZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbYBZHZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYBZHZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:25:00 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:53774 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYBZHZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GyK5C2kNWDDWB8+XSi0hTyfHya7JYk9jFywVKTF43boYXfpPzk7QDLxGIOTGuYqVtdPnK6Q7wvpXzHt5FN5x+kHE2FJk0mKmK435cVSy31AU5lywuRQtzp+5LpjolYJ9yYeXuNpfDiqjDfMiUbp8ZOokbdzBY8dEl/gXQrVd8+s=
Message-ID: <86802c440802252324u769f087fw83caa26c1960354e@mail.gmail.com>
Date: Mon, 25 Feb 2008 23:24:56 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86_64: remove wrong setting about CONSTANT_TSC for intel cpu
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080226072035.GB24820@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802252320.01534.yinghai.lu@sun.com>
	 <20080226072035.GB24820@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
>
> > also fix error in early_init_intel and reference about x86_capality,
>  > because it is array already.., prevent possible data corruption...
>
>  hm, why should there be data corruption:
>
>
>  > -             set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
>  > +             set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>
>  cpu_cpu_cap() is currently defined as:
>
>   #define set_cpu_cap(c, bit)     set_bit(bit, (unsigned long *)((c)->x86_capability)
>
>  which is the same. set_cpu_cap() is indeed the cleaner form to do this
>  so your patch is correct as a cleanup.
set_cpu_cap is right
==
set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability); ===> is wrong
should be
set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);

x86_capability is a array ...

so this could prevent some data corruption.

YH
