Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZDAALU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZDAALU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759138AbZDAAKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:10:30 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38106 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763725AbZDAAK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:10:29 -0400
Subject: Re: [patch 25/45] SCSI: sg: fix races during device removal
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tony Battersby <tonyb@cybernetics.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <alpine.LFD.2.00.0903311628030.4130@localhost.localdomain>
References: <20090331231045.719396245@sous-sol.org>
	 <20090331231609.657243922@sous-sol.org>
	 <alpine.LFD.2.00.0903311628030.4130@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 00:10:20 +0000
Message-Id: <1238544620.5000.5.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 16:31 -0700, Linus Torvalds wrote: 
> 
> On Tue, 31 Mar 2009, Chris Wright wrote:
> > 
> > From: Tony Battersby <tonyb@cybernetics.com>
> > 
> > upstream commit: c6517b7942fad663cc1cf3235cbe4207cf769332
> > 
> > sg has the following problems related to device removal:
> 
> Hmm. Is this a new problem to 2.6.29?

No, it's fairly old

> The patch is pretty big (certainly _way_ over the official -stable limit), 
> and I don't know how critical or new this bug was. I doubt it has gotten 
> much testing in the development branch either, yet.

Well, I considered the patch too high risk for -rc, so we elected to put
it into the development branch with the understanding that we'd backport
it to 2.6.29 provided it proved stable.

The races it fixes are hard to trigger.  However, we do have an oops
report on it:

http://marc.info/?l=linux-kernel&m=123316111415677

or at least which is fixed by the three patch series.

> So please convince me that this shouldn't wait a bit, or at least point me 
> to the problem reports to convince me that the size limit should be 
> ignored.

I think we could wait a bit to see if any issues turn up in 2.6.30
testing.  I think it should go in eventually, though.

James


