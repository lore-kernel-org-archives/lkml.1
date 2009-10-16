Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZJPDC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZJPDC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 23:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZJPDC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 23:02:58 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:57135 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbZJPDC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 23:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EhdZNMXjBz8GEIE9PpNQS2It8lJEZvI2/mGo2IHbSljuXShnv2FQ7BPJHknOzPFzPf
         6dFX6jZeQ+N3mgtm/0OluCM4N4EMErWdVzwnXbK9BegupNkKxeEuj9Ar4LWlCbEAWRJd
         KDi+DedYOCbIv8gShrs08w4Ro6D/Fu0jhEHLM=
MIME-Version: 1.0
In-Reply-To: <20091015215215.GG15898@elf.ucw.cz>
References: <20091006074635.GA2775@ucw.cz> <20091007085806.GB28807@elf.ucw.cz> 
	<1254914991.4213.80.camel@hammer.suse.cz> <20091007120643.GA17069@rakim.wolfsonmicro.main> 
	<f17812d70910070727x47b2a22h8e9f9304740d5abf@mail.gmail.com> 
	<20091006200933.GA1606@ucw.cz> <1255641385.3985.55.camel@utx.utx.cz> 
	<20091015212024.GC15898@elf.ucw.cz> <1255643252.3985.63.camel@utx.utx.cz> 
	<20091015215215.GG15898@elf.ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 16 Oct 2009 11:01:31 +0800
Message-ID: <f17812d70910152001r7b5b0326s5f0e880cca3b3b68@mail.gmail.com>
Subject: Re: spitz: add gpio button support (fixes regression)
To: Pavel Machek <pavel@ucw.cz>
Cc: Stanislav Brabec <utx@penguin.cz>, Andrew Morton <akpm@osdl.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 5:52 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Thu 2009-10-15 23:47:32, Stanislav Brabec wrote:
>> Pavel Machek wrote:
>> >Well, resume is hit by second regression.
>> >
>> >Suspend key.... I restored it to the level of functionality in
>> >2.6.31 :-).
>>
>> > > +         .type   = EV_KEY,
>> > > +         .code   = KEY_SUSPEND,
>>
>> I guess it should be EV_PWR. Then it will at least go to suspend.
>
> Does it actually go to suspend with that change?
>
> (Actually, I wonder how it could have ever worked: userspace should
> certainly be in a loop there; kernel should not suspend machine on its
> own. In -rp kernels, kernel _does_ suspend on its own, but... I'm not
> sure if that's suitable for mainline).

EV_PWR is what's in the original spitzkbd.c, so I assume that's
something we should keep. And the reason that EV_PWR makes
it actually suspend might related the APM emulation things,
which I'm not very sure about.
