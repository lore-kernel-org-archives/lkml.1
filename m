Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXI1XF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXI1XF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbXI1XFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:05:47 -0400
Received: from alnrmhc12.comcast.net ([204.127.225.92]:63512 "EHLO
	alnrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbXI1XFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:05:45 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 19:05:45 EDT
Subject: Re: Out of memory management in embedded systems
From: Nicholas Miell <nmiell@comcast.net>
To: Rik van Riel <riel@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Daniel =?ISO-8859-1?Q?Sp=E5ng?= <daniel.spang@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070928111546.0c290e57@bree.surriel.com>
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
	 <Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com>
	 <cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com>
	 <Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com>
	 <20070928101711.504eb198@bree.surriel.com>
	 <20070928163634.d7fc8909.dada1@cosmosbay.com>
	 <20070928111546.0c290e57@bree.surriel.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 28 Sep 2007 16:00:39 -0700
Message-Id: <1191020439.2702.3.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 11:15 -0400, Rik van Riel wrote:
> On Fri, 28 Sep 2007 16:36:34 +0200
> Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > On Fri, 28 Sep 2007 10:17:11 -0400
> > Rik van Riel <riel@redhat.com> wrote:
> > 
> > > On Fri, 28 Sep 2007 10:04:23 -0400
> > > "linux-os \(Dick Johnson\)" <linux-os@analogic.com> wrote:
> > > > On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
> > > > 
> > > > > On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> > > > >>
> > > > >> On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
> > > 
> > > > >>> Some kind of notification to the application that the available memory
> > > > >>> is scarce and let the application free up some memory (e.g., by
> > > > >>> flushing caches), could be used to improve the situation 
> > > 
> > > > Any networked appliance can (will) throw data away if there are
> > > > no resources available.
> > > 
> > > That is exactly what Daniel proposed in his first email.
> > > 
> > > I think his idea makes sense.
> > 
> > IBM AIX uses SIGDANGER, that kernel can raise in OOM conditions to warn
> > processes that are willing to handle this signal (default action for the
> >  SIGDANGER signal is to ignore the signal)
> 
> I suspect that SIGDANGER is not the right approach, because glibc
> memory arenas cannot be manipulated from inside a signal handler.
> 
> Also, "nearly OOM" is not the only such signal we would want to
> send to userspace programs. It would also be useful to inform
> userspace programs when we are about to start swapping something
> out, so userspace can discard cached data instead of having to
> wait for disk IO in the future.
> 
> A unix signal cannot encapsulate two different messages, while
> something like a "/dev/lowmem" device can simply be added into
> the program's main poll() loop and give many different messages.

SIGDANGER could stick useful information in siginfo_t's si_code field
and be delivered via a signalfd.

-- 
Nicholas Miell <nmiell@comcast.net>

