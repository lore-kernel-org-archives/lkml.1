Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZHFWgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZHFWgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 18:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZHFWgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 18:36:37 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:61344 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZHFWgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 18:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BOdH5XiyTeyTDlPEP7095f/JpA+ZeYR3meJj5/vBXolyCmdtbJtNnVlREPNfqrqEb3
         BOKSBNtQVuVaycq+0DT8e7IIEuXZ34GubGktOkhvVWjuv9FnmgqeBqcfLd7Fcp8kJd6b
         KYKslmp27NxZVC3ND9UThOGhOVgJ/IFEnrGUs=
MIME-Version: 1.0
In-Reply-To: <20090731123711.GA5421@elte.hu>
References: <alpine.LFD.2.00.0907302158180.2936@localhost.localdomain>
	 <alpine.LFD.2.01.0907301648540.3161@localhost.localdomain>
	 <20090731123711.GA5421@elte.hu>
Date: Thu, 6 Aug 2009 15:36:36 -0700
X-Google-Sender-Auth: 17233f2e741a953d
Message-ID: <1f1b08da0908061536o57cebeb6r2f522cb3c5419e1@mail.gmail.com>
Subject: Re: [GIT pull] timers fixes for 2.6.31
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 5:37 AM, Ingo Molnar<mingo@elte.hu> wrote:
> [ Markus, John: the fix looks right for .31 but i think there's two
>  small structural problems with this code, which might have
>  contributed to the bug to happen to begin with:
>
>  Firstly, ->mult_orig is a slight misnomer - if it was named
>  properly we wouldnt even need the comments to explain how to use
>  and update it. It's the unadjusted multiplicator while _orig
>  patterns in the kernel generally suggest some sort of save/restore
>  pattern (which this is not).
>
>  I'd suggest to rename it to ->mult_unadjusted, ->mult_raw or
>  ->mult_static instead. This field has not gotten into many
>  clocksource drivers yet so it's easy to do. For .32 obviously.
>
>  Secondly, the broader design question is: why are clocksource
>  drivers mucking around with NTP details? Whether NTP is running
>  should be a transparent detail to drivers and if such details are
>  visible in low level driver (which they are in
>  arch/arm/plat-omap/common.c et al) that's sign of uncleanliness.
>  Mind improving that? (for .32 too)

Well, the clocksources aren't really mucking with NTP details, but NTP
mucks with the clocksource.  And so this was a way to try to preserve
the original mult value,  and I'll admit was a bit stapled on.  This
mostly comes from how the clocksource structure has swelled over time
to include quite a bit of timekeeping specific information.

Splitting this up has been on my list for awhile, but I've never
gotten to it. However, Martin Schwidefsky has been doing a great job
with his latest patches cleaning up some of uglier parts of the
timekeeping/clocksource interactions. There is still lots of  changes
I'd like to see, but they will take time as we still haven't gotten
all the arches over to GENERIC_TIME, so some cruft has to stick
around.   But Martin's patches are a great big step towards it and
hopefully his patches will be ready for .32.

thanks
-john
