Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZJFMzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZJFMzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbZJFMzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:55:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212AbZJFMzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:55:09 -0400
Date: Tue, 6 Oct 2009 14:54:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, hch@infradead.org
Subject: Re: [RFC][PATCH 0/9] perf trace: support for general-purpose
	scripting
Message-ID: <20091006125420.GC15320@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com> <c62985530910060240y6755a8acgf235db0845202540@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530910060240y6755a8acgf235db0845202540@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2009/10/6 Tom Zanussi <tzanussi@gmail.com>:
> > Hi,
> >
> > This patchset defines a generic interface for processing the binary
> > output of 'perf trace' and making it directly available to
> > user-defined scripts written in general-purpose scripting languages
> > such as Perl or Python.  It also builds a general-purpose Perl
> > scripting trace processor on top of the new interface and provides a
> > few example scripts that exercise the basic functionality.
> >
> > The main motivation behind it is to provide a more efficient and
> > powerful alternative to the popular method of parsing the ascii trace
> > output in order to extract useful information from it.  To avoid the
> > overhead and complexity of all that, this patchset provides a
> > direct-to-script-interpreter pathway for doing the same thing, but in
> > a more regularized fashion, one that takes advantage of all the event
> > meta-info provided by the tracing infrustructure, such as the
> > event/field info contained in the 'format files' designed for that
> > purpose.
> 
> 
> That's really a great thing! I was also hesitating to implement a 
> python interface to perf in order to quickly plug post processing 
> tools. But your patchset does that in a much more generic way that I 
> imagined: we can support other languages, we have well defined 
> callbacks to process the events...
> 
> Really nice, I hope we can give it a try in -tip soon.

Agreed! There's a few details to be improved and the license needs to be 
kernel compatible but all in one, this is really great stuff! Ad-hoc 
scripting based on the binary data stream is a quite powerful concept 
IMO.

We might be able to inject more complete data structures into the 
scripting space as well in the future, if the C side grows them. I.e. we 
could have a healthy mixture of fast C code that provides not just a 
dumb stream of records but also metadata and higher level data 
structures, plus scripting.

One open question would be compatibility. I think initially we dont want 
to provide format guarantees and script guarantees - this area is still 
too fluid to pin down random details.

	Ingo
