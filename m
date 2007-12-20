Return-Path: <linux-kernel-owner+w=401wt.eu-S932233AbXLTM0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbXLTM0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbXLTMZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:25:49 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:5001 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976AbXLTMZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:25:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DpaHFzDzmJJdkIsHFnx+yL2/JReItDPhTYIRt1/0uU10iC7rMqIYsSvs56Ok+KLeA/RBnYO/NsPWm4Zj2lELcGJ6P4+9WbA/QmxSHJepkZpTV06lWsGwvNoOl6nKImfGxPGJQMMrQQAjt9yCJPFnEB+EC8fyvSFYaM/UnYxmAUA=
Message-ID: <3efb10970712200425x4b0ffadcpd2ffa3223eda7b3d@mail.gmail.com>
Date: Thu, 20 Dec 2007 13:25:44 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Jaswinder Singh" <jaswinderlinuxrt@gmail.com>
Subject: Re: [patch 3/3] Enable setting of IRQ-thread priorities from kernel cmdline. (repost:CC to LKML)
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Ingo Molnar" <mingo@elte.hu>, "Juergen Beisert" <jbe@pengutronix.de>,
       "Darren Hart" <dvhltc@us.ibm.com>, linux-rt-users@vger.kernel.org,
       "Sven-Thorsten Dietrich" <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1985e0f60712200359k6194b0fdn25ead9b5c0835c95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071219194551.315868746@bohmer.net>
	 <47697888.143f420a.5466.ffff89ba@mx.google.com>
	 <1985e0f60712200359k6194b0fdn25ead9b5c0835c95@mail.gmail.com>
X-Google-Sender-Auth: d3eda966a0cccbea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jaswinder,

> Is it possible to run softirq-threads or IRQs as a non-realtime tasks
> in RT kernel.

Currently the answer is no. (Unless overruled from userspace) I did
not take this requirement into account.
So, Is this a serious requirement? Should this be possible?
I cannot imagine a purpose in which that is wanted, it would cause
unpredictable interrupt handling, and I can imagine that many
drivers/devices will not like that.

The purpose is usually to spread the threads across several
priorities, to create room for some RT-process to become more
important than an IRQ that generates large latencies, and each
RT-system designer shall divide the priorities different, due to
different system requirements.

Kind Regards,

Remy

2007/12/20, Jaswinder Singh <jaswinderlinuxrt@gmail.com>:
> On 12/20/07, Remy Bohmer <linux@bohmer.net> wrote:
> > The RT-patch originally creates all its softirq-threads at
> > priority 50.
>
> Is it possible to run softirq-threads or IRQs as a non-realtime tasks
> in RT kernel.
>
> If yes, then how.
>
> Thank you,
>
> Jaswinder Singh.
>
