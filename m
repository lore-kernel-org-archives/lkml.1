Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYKYRNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYKYRNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYKYRNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:13:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:38071 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYKYRNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:13:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=c5uirs4a4vj6s1mQhjFuPYq/mZXNgI2vc/UngjK5NCZjTFV7XvTiwd8H2gMyOC2bTj
         LWjPiiamnHojbGWVnl8ZidKn+NppLgRpXKk9yKZ4ON4FR9NQj0M4cB2gbH5ton1bVtQ5
         zMMJ9eX3dTDX8EiN5dm0NgyuBk6vXyfCLaLyg=
Date: Tue, 25 Nov 2008 19:13:33 +0200
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mmiotrace: fix buffer overrun detection
Message-ID: <20081125191333.4273ae81@daedalus.pq.iki.fi>
In-Reply-To: <c62985530811250359s42f1eb72kb65a5ac1a510d0d1@mail.gmail.com>
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
	<20081123212430.4f6700e9@daedalus.pq.iki.fi>
	<20081123193413.GB2794@elte.hu>
	<20081124221849.33c91bcf@daedalus.pq.iki.fi>
	<c62985530811241230x601a27e1w504b0564b9513a13@mail.gmail.com>
	<20081124232720.59312c0d@daedalus.pq.iki.fi>
	<c62985530811250355r6e1510fdv1a63ef89e6c06c94@mail.gmail.com>
	<c62985530811250359s42f1eb72kb65a5ac1a510d0d1@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 12:59:22 +0100
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 2008/11/25 Frédéric Weisbecker <fweisbec@gmail.com>:
> > Perhaps that:
> >
> > int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
> > {
> >     ......
> >     if (tracing_disabled)
> >                return 0;
> 
> Since this is the return value for tracing_mark_write(), it may better
> return an error to avoid a spin when tracing
> is disabled. -ENODEV I guess, or -EBUSY
> 
> The strange thing is that tracing_open_generic() shoud have return
> -ENODEV in this case during the opening of trace_mark.
> 

This sounds worth investigating, thanks for the tip.
Hmm, maybe if I changed the current tracer while trace_enabled was
zero...

Anyway, this isn't too high on my priority list.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
