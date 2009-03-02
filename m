Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbZCBRxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbZCBRxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZCBRx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:53:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60236 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZCBRx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:53:28 -0500
Date: Mon, 2 Mar 2009 12:53:24 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ftrace: add ftrace_bprintk()
In-Reply-To: <c62985530903020945i6098682bh59a5c6d6c6de759c@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0903021252420.4771@gandalf.stny.rr.com>
References: <20090228091305.GA20533@elte.hu>  <49aa088b.1c07d00a.4512.ffffe781@mx.google.com>  <alpine.DEB.2.00.0903021128380.4771@gandalf.stny.rr.com> <c62985530903020945i6098682bh59a5c6d6c6de759c@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-609446669-1236016405=:4771"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-609446669-1236016405=:4771
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Mon, 2 Mar 2009, Fr?d?ric Weisbecker wrote:
> >> +
> >> +static
> >> +void release_module_trace_bprintk_format(const char **start, const ch=
ar **end)
> >> +{
> >> + =A0 =A0 const char **iter;
> >> + =A0 =A0 lock_btrace();
> >> + =A0 =A0 for (iter =3D start; iter < end; iter++) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 struct trace_bprintk_fmt *tb_fmt;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!*iter)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 tb_fmt =3D container_of(*iter, struct trace_=
bprintk_fmt, fmt[0]);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 tb_fmt->count--;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!tb_fmt->count && !btrace_metadata_count=
) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&tb_fmt->list);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(tb_fmt);
> >
> > Shouldn't *iter get assigned to NULL somewhere here?
> >
> > -- Steve
>=20
>=20
> Hm, why?

Well, after we free tb_fmt, the *iter will then point to garbage. Right?

-- Steve
--8323328-609446669-1236016405=:4771--
