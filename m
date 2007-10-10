Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXJJPgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXJJPgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbXJJPfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:35:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44621 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbXJJPfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:35:54 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH 3/3] V4L: cinergyT2, remove bad
	usage of ERESTARTSYS
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: video4linux-list@redhat.com, Jiri Slaby <jirislaby@gmail.com>,
       daniel@qanu.de, linux-kernel@vger.kernel.org, holger@qanu.de,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <470C5294.8060502@linuxtv.org>
References: <24841282012868130110@pripojeni.net>
	 <1191979260.5492.32.camel@gaivota>  <470C5294.8060502@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Oct 2007 12:35:41 -0300
Message-Id: <1192030541.5896.54.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qua, 2007-10-10 às 00:18 -0400, Michael Krufky escreveu:
> 
> Is this illegal as per kernel codingstyle?

Yes, it is. CodingStyle states:

"Don't put multiple statements on a single line unless you have
something to hide"
	and
"Don't put multiple assignments on a single line either.  Kernel coding style
is super simple.  Avoid tricky expressions."

So, Kernel's script/checkpatch.pl is right when complaining about it.

>   I could understand if we may
> want to avoid this sort of thing for the sake of code readability, but
> this seems 100% proper to me, especially considering that we're simply
> trying to catch an error return code.

> One of the things that I really enjoy about the c programming language
> is the fact that you can string many operations together into a single
> statement through the use of logic.

Yes, this is a great C feature, especially to obfuscate a source code.
On C, it is possible to write very complex code, with several
statements, on a single clause, like:

if((c=(a=x,x-=c,++a)>6?1:-1)>0)goto foo;

The above code is valid under C, and won't produce a single compiler
warning. An experienced C programmer will understand the above code,
while non-experienced ones, even with large experience on other
programming languages, may take hours to understand.

A large code, with lots of the above style will be very painful to
analyze, even for advanced programmers. So, especially on big projects,
with lots of contributors, this should really be avoided. 

> I hate the thought of a patch being nacked because of the above.  :-/
> If this is indeed kernel codingstyle, then IMHO, we should let it slide
> for catching error return codes.

It is just a matter of a simple CodingStyle fix.

The proper fix is just to replace the offended code by this:

err=foo();
if (error)
	goto error;

-- 
Cheers,
Mauro

