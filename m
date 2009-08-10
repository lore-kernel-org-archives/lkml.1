Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbZHJR1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbZHJR1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbZHJR1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:27:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47160 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932388AbZHJR1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:27:15 -0400
Date: Mon, 10 Aug 2009 18:27:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Artur Skawina <art.08.09@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: xterm loses data (pty regression)
Message-ID: <20090810182743.1642217f@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0908101016100.3288@localhost.localdomain>
References: <4A803CE7.20201@gmail.com>
	<2c0942db0908101007t54c39b64k2800b2c320969318@mail.gmail.com>
	<alpine.LFD.2.01.0908101016100.3288@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 10:18:41 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 10 Aug 2009, Ray Lee wrote:
> > On Mon, Aug 10, 2009 at 8:29 AM, Artur Skawina <art.08.09@gmail.com> wrote:
> > >
> > > First noticed it after upgrading to v2.6.31-rc5-246-g90bc1a6, still happens
> > > in rc5-381-g7b2aa03.
> > > If i press ^S in an xterm the output stops as expected, but after a ^Q i see
> > > only the newly written data, everything in between is lost. 
> 
> Yup, I can confirm that. 
> 
> > > > for i in `seq 1 111`; do echo $i; sleep 1; done
> 
> (Do ^S/^Q, see data loss)
> 
> Will take a look asap, thanks. Although I bet it's the same old commit 
> (d945cb9cc: "pty: Rework the pty layer to use the normal buffering logic") 
> again.

My guess too. The old pty code abuses throttle/unthrottle in odd ways.
