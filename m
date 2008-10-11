Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbYJKUDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbYJKUDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYJKUDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:03:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:4514 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbYJKUDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pNWu//dLHTuQ5CIJifHwSi4KMWucer7Jk08U7mEtMZqH54NEoeWqTPiyqEhHme8cBS
         ENshkWK5flRNn4/pIoRjmVuJd46axXmdWYpPrTE698psh+imzrFsWuF4gIubSczuWzrM
         lwvpItfZ4LiczMNNyFvVuO30Jk4KvU7Sw0S50=
Message-ID: <c62985530810111303h2ac6e02ewf54765717895c949@mail.gmail.com>
Date: Sat, 11 Oct 2008 22:03:18 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 6/6] tracing/fastboot: Print ktime of sched events when boot tracing
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081010194530.GA31401@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010123450.8D3E6D1BCF0@perso1.free.fr>
	 <20081010140534.GB13137@elte.hu> <20081010194530.GA31401@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/10 Ingo Molnar <mingo@elte.hu>:
> hm, there's a new build failure:
>
> kernel/built-in.o: In function `boot_trace_init':
> trace_boot.c:(.text+0x5ee38): undefined reference to `sched_switch_trace'
> kernel/built-in.o: In function `disable_boot_trace':
> (.text+0x5eee1): undefined reference to `tracing_stop_cmdline_record'
> kernel/built-in.o: In function `enable_boot_trace':
> (.text+0x5ef11): undefined reference to `tracing_start_cmdline_record'
>
> this revert solves the problem:
>
> commit b80bebdc1718c02947468df227b7f4414d8dcce8
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Oct 10 21:44:24 2008 +0200
>
>    Revert "tracing/fastboot: use sched switch tracer from boot tracer"
>
>    This reverts commit 124cecce4145c590ae391fe12962653be8a05658.
>
> Config attached.
>
>        Ingo
>

....I guess that could happen when the boot tracer is configured
whithout the sched_switch tracer.
I will send a patch to add this dependance on the Kconfig...

Thanks.
