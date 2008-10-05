Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYJEAZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYJEAZL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 20:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYJEAY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 20:24:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:51523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYJEAY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 20:24:58 -0400
Date: Sat, 4 Oct 2008 17:24:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "=?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker" <fweisbec@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] fix printk format typo in boot ftracer.
Message-ID: <20081004172449.58e53afd@infradead.org>
In-Reply-To: <c62985530810041358p1cc361b1te89894cedcd7e3b3@mail.gmail.com>
References: <20081004134227.465fa20c@infradead.org>
	<c62985530810041358p1cc361b1te89894cedcd7e3b3@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008 22:58:12 +0200
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> > -               ret = trace_seq_printf(s, "[%5ld.%06ld] initcall %s
> > "
> > +               ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s
> > " "returned %d after %lld msecs\n",
> >                                          rettime.tv_sec,
> >                                          rettime.tv_nsec,
> 
> I picked these formats from the printk.c time formatting. But you're
> right, 09 would give us the whole nano precision.

it's more than precision, it's correctness.

doing "0.%02i" will do
0.100  if you pass it 100 and
0.10   if you pass it 10

and most off the time, except the first 0.1 seconds, you'll be passing
it 9 digits, but the first 0.1 seconds.. the %06 will just give really
incorrect results.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
