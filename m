Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbZEUANd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbZEUANd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZEUANW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:13:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55618 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbZEUANW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:13:22 -0400
Date: Wed, 20 May 2009 20:13:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Anton Blanchard <anton@samba.org>, mingo@elte.hu, tzanussi@gmail.com,
       jbaron@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/events: Add timer and high res timer
 tracepoints
In-Reply-To: <c62985530905201701i36527eblae479c07eec06515@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0905202011330.1080@gandalf.stny.rr.com>
References: <20090520101334.GA23442@kryten> <c62985530905201701i36527eblae479c07eec06515@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-689363391-1242864801=:1080"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-689363391-1242864801=:1080
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Thu, 21 May 2009, Fr=E9d=E9ric Weisbecker wrote:

> 2009/5/20 Anton Blanchard <anton@samba.org>:
> > +/**
> > + * timer_entry - called immediately before the timer
> > + * @timer: pointer to struct timer_list
> > + *
> > + * When used in combination with the timer_exit tracepoint we can
> > + * determine the timer latency.
> > + */
> > +TRACE_EVENT(timer_entry,
> > +
> > + =A0 =A0 =A0 TP_PROTO(struct timer_list *timer),
> > +
> > + =A0 =A0 =A0 TP_ARGS(timer),
> > +
> > + =A0 =A0 =A0 TP_STRUCT__entry(
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __field(void *, function)
>=20
>=20
>=20
> void * won't make the filtering easier.
> It would require the raw address whereas it would be nice to filter
> by function name.
>=20
> But saving the address instead of the resolved name is faster.
>=20
> I guess we should add a filter feature to resolve a function name to
> its address.

Yeah, I think that would be the better approach. This should be easy since=
=20
the function pointers being saved are the actual address of the function=20
and not an offset into the function. A simple filter on kallsyms should be=
=20
enough.

-- Steve

--8323328-689363391-1242864801=:1080--
