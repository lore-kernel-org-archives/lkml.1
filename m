Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbYIFNt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbYIFNt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 09:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYIFNtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 09:49:20 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:3430 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYIFNtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 09:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=pThJTd+80Q40sS6y0TLVajHILNS81w5Up85WiiFYVZq4J/6X1H6hDqxLa+NqrwBvm9
         Lo6RPi68bJwAbDSCBTRINZT+jIZG4MIn6z1Ns4hnmeNZalGsHqCe4icIo4rCB4RvHpSu
         /EEn+MmlFyhf09vBvKHcnd0H/KgYUC2y7LaG8=
Date: Sat, 6 Sep 2008 16:49:09 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Message-ID: <20080906164909.4b6f3a49@daedalus.pq.iki.fi>
In-Reply-To: <c62985530809060439r2dffedd8kd6ac9e061f1273c3@mail.gmail.com>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	<c62985530809060439r2dffedd8kd6ac9e061f1273c3@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008 13:39:55 +0200
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 2008/9/4 Steven Rostedt <rostedt@goodmis.org>:
> 
> > For logdev (my pet project from way back, and the latest ftrace is based
> > on), I had a CUSTOM type. The API allowed to register a callback to a
> > type, and it would associate that type to some number (descriptor) and
> > pass that number back to you. Then you could use this number to write to
> > the buffer using the CUSTOM type and registered number. On output, when a
> > CUSTOM type is detected, it would read the custom.id (the number) and
> > search for any registered callbacks to handle the entry.
> >
> > This probably would not be too difficult to implement. Especially since it
> > is already implemented in logdev.
> > (see http://rostedt.homelinux.com/logdev/)
> >
> > -- Steve
> 
> Why not. It is a way for a tracer to handle output for any type of entries.
> But will this feature really be used for other special types than
> TRACE_PRINT? I'm not sure... If it is not the case, the Pekka's
> solution seems to me far more simple.
> 
> But actually I don't know the needs of others tracers...

I never thought TRACE_PRINT would need anything more. At least I'm happy
with the concept of TRACE_PRINT, it just needs some adjustments in the API
to be nice to use.

True, I might some day want to add yet another entry type for mmiotrace,
but I'm not planning that for now, and I could just add it like they are
in the current framework. But the benefit of the CUSTOM type would be
to allow modularized and out-of-tree tracers. And then, why keep the
current predefined types, why not make everything a CUSTOM type? Just
define a block size in the ring buffer and use TRACE_CONT to handle
payload larger than the block.

Anyway, personally I'm satisfied with the current state of the framework
and I can only talk for mmiotrace.


Cheers,
pq

-- 
Pekka Paalanen
http://www.iki.fi/pq/
