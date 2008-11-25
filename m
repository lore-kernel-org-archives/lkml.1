Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYKYL7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYKYL7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYKYL7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:59:24 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:19556 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYKYL7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:59:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UnrHf1LTCl1hyDtKBBmicj08WMqnz4QUopi3XY0HUyyXVm1TTB6WYoDJlLDiAasJeo
         VZZiGx7fecL7Gwqn9ZjQQnzEOKJZzKSVOONVNwCKPv5fWv2MqHWTzgWvZjWtKahIgQyI
         ENCcQwLB+LjjNNgCOfcXVqyzyQZOvGUp33dLU=
Message-ID: <c62985530811250359s42f1eb72kb65a5ac1a510d0d1@mail.gmail.com>
Date: Tue, 25 Nov 2008 12:59:22 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [PATCH 1/2] mmiotrace: fix buffer overrun detection
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530811250355r6e1510fdv1a63ef89e6c06c94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
	 <alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
	 <20081123212430.4f6700e9@daedalus.pq.iki.fi>
	 <20081123193413.GB2794@elte.hu>
	 <20081124221849.33c91bcf@daedalus.pq.iki.fi>
	 <c62985530811241230x601a27e1w504b0564b9513a13@mail.gmail.com>
	 <20081124232720.59312c0d@daedalus.pq.iki.fi>
	 <c62985530811250355r6e1510fdv1a63ef89e6c06c94@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/25 Frédéric Weisbecker <fweisbec@gmail.com>:
> Perhaps that:
>
> int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
> {
>     ......
>     if (tracing_disabled)
>                return 0;

Since this is the return value for tracing_mark_write(), it may better
return an error to avoid a spin when tracing
is disabled. -ENODEV I guess, or -EBUSY

The strange thing is that tracing_open_generic() shoud have return
-ENODEV in this case during the opening of trace_mark.
