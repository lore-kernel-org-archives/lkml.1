Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXDJBTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXDJBTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 21:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbXDJBTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 21:19:05 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39486 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbXDJBTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 21:19:02 -0400
Date: Mon, 9 Apr 2007 18:18:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
Message-Id: <20070409181833.53eb2be9.akpm@linux-foundation.org>
In-Reply-To: <20070410011257.GC2986@holomorphy.com>
References: <20070404172931.GM2986@holomorphy.com>
	<20070404194829.1a93d8fd.dada1@cosmosbay.com>
	<20070404181050.GN2986@holomorphy.com>
	<20070409165315.4704021f.akpm@linux-foundation.org>
	<20070410004201.GA2986@holomorphy.com>
	<20070409175352.0474a3c9.akpm@linux-foundation.org>
	<20070410011257.GC2986@holomorphy.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 18:12:57 -0700
William Lee Irwin III <wli@holomorphy.com> wrote:

> On Mon, 9 Apr 2007 17:42:01 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
> >>  My use for it is report generation in VM (and possibly other)
> >> testcases.
> 
> On Mon, Apr 09, 2007 at 05:53:52PM -0700, Andrew Morton wrote:
> > OK.  The cool kids are using taskstats for this sort of thing now, but I
> > note that taskstats is inexplicably missing the context-switch accounting,
> > and perhaps other things?
> 
> Sounds interesting. I'll poke around there for testcase affairs if I
> get moving on them first. I've no sentimental attachment to the rusage
> patch, so if taskstats do happen to displace this, I'm not concerned.
> (That said, it may still make sense to do this for the purposes of API
> compatibility. I'll keep it moving along until it's all decided.)
> 

rusage() is a bit easier to use, as it delivers synchronously at task exit.
 taskstats delivers over netlink into a separate process (and can be polled
at any time during task execution) but does require new skills, more
(Linux-specific) code and perhaps more complex synchronisation.

