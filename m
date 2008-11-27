Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYK0Nap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYK0Nap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYK0Nae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:30:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:13126 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYK0Nad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:30:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=G8F3EXNwOAKSyZn6jJi3KEBzgEeN1fc6Qy9IEx/uLjdQYN0mGvSpV+9pOULrVfUigj
         K/Q2VJVO0a1cFyyWSCq/zgFLajiUL6Q+HZ7zUUy+zX6QmlBSHNU4N00VtbtILrXzQOjY
         YbPrWD9hczSY2/uyJjz630kFozaHcEWJTrNq0=
Message-ID: <7c86c4470811270530j4f3c5413j9e6e68cee08631a9@mail.gmail.com>
Date: Thu, 27 Nov 2008 14:30:31 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Cc: "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <20081127124501.GL6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
	 <20081126140054.GX6703@one.firstfloor.org>
	 <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain>
	 <20081127100602.GF6703@one.firstfloor.org>
	 <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
	 <20081127113115.GH6703@one.firstfloor.org>
	 <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
	 <20081127123257.GI6703@one.firstfloor.org>
	 <7c86c4470811270428r76702954se8f6e005481a6a35@mail.gmail.com>
	 <20081127124501.GL6703@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 1:45 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> What if a threads reprograms the counters while another is reading them?
>
> In the worst case you get an invalid event, which is then discarded.
> I think. I've never tried to understand it in all details, but
> at least it seems to work.
>
>> How is the buffer reset?
>
> drivers/oprofile/cpu_buffer.c:
>
> /* Resets the cpu buffer to a sane state. */
> void cpu_buffer_reset(struct oprofile_cpu_buffer *cpu_buf)
> {
>        /* reset these to invalid values; the next sample
>         * collected will populate the buffer with proper
>         * values to initialize the buffer
>         */
>        cpu_buf->last_is_kernel = -1;
>        cpu_buf->last_task = NULL;
> }
>
What about a thread doing this and another one in the middle of read the buffer?

Or what about a thread trying to reset the buffer while you're processing an PMU
interrupt on another CPU. I know each buffer is per-CPU, but that does not
prevent two threads for trying to operate on it at the same time from
different CPUs.
