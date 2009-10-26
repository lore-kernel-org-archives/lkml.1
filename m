Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZJZKIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZJZKIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 06:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZJZKIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 06:08:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:37532 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbZJZKIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 06:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DGgZaziyV4Ld75lUu0jTWsCk9a7vHrSzzbKdotyzUiWB3Rf5+HEam1ClYQ7LIbJaSK
         toSLNJxuqDaBPIi/QFlGIeaNu/yyMm2WhDvFb1otS4Ps+D2AzFkM0biIhKEMVibZUH/H
         NAc7bDNPFqO/f1BRha+hbR/MMvyuz/ET7w0Kg=
MIME-Version: 1.0
In-Reply-To: <20091026094729.GB13517@linux-sh.org>
References: <20091026054000.GA13517@linux-sh.org>
	 <20091026062520.GA29580@elte.hu> <20091026094729.GB13517@linux-sh.org>
Date: Mon, 26 Oct 2009 12:08:34 +0200
X-Google-Sender-Auth: a9be069eae1e7d85
Message-ID: <84144f020910260308r106574e3vdd72e8697571bdc2@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Kill off -Wcast-align
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mundt <lethal@linux-sh.org> wrote:
>> > The present use of -Wcast-align causes the build to blow up on SH due to
>> > generating a "cast increases required alignment of target type" error on
>> > each invocation of list_for_each_entry().
>> >
>> > It seems that this was previously reported and killed off in the ia64
>> > support patch, but nothing seems to have happened with that. Presumably
>> > the same problem still remains there, too.
>> >
>> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>

On Mon, Oct 26, 2009 at 07:25:20AM +0100, Ingo Molnar wrote:
>> Is this a GCC bug producing false positive warnings? The GCC manpage
>> says:
>>
>>        -Wcast-align
>>            Warn whenever a pointer is cast such that the required alignment of the
>>            target is increased.  For example, warn if a "char *" is cast to an
>>            "int *" on machines where integers can only be accessed at two- or
>>            four-byte boundaries.
>>
>> Which looks moderately useful - if it works.

On Mon, Oct 26, 2009 at 11:47 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> Well, both ia64 and sh have hit this in the current compilers, and it
> doesn't seem to pose any code generation issues. In the areas where it is
> generated it seems to relate to 64-bit data types in the data structures,
> which in itself doesn't seem inherently problematic.
>
> I'll submit a bug report to the GCC folks, but for the time being given
> that multiple architectures are hitting this and it doesn't seem to be
> causing any issues, it would be better to have this flag dropped.

Can we disable the flag for affected architectures but keep it enabled for x86?
