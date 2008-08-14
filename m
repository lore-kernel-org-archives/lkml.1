Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYHNE04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYHNE04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 00:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbYHNE0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 00:26:48 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41365 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYHNE0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 00:26:48 -0400
Subject: Re: request->ioprio
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?=E5=90=89=E5=B7=9D_=E6=8B=93=E5=93=89?= 
	<yoshikawa.takuya@oss.ntt.co.jp>,
       dpshah@google.com
In-Reply-To: <200808141216.33688.rusty@rustcorp.com.au>
References: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp>
	 <200808070633.06112.rusty@rustcorp.com.au>
	 <1218611163.8001.108.camel@sebastian.kern.oss.ntt.co.jp>
	 <200808141216.33688.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Thu, 14 Aug 2008 13:26:46 +0900
Message-Id: <1218688006.30624.9.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 12:16 +1000, Rusty Russell wrote:
> On Wednesday 13 August 2008 17:06:03 Fernando Luis Vázquez Cao wrote:
> > Besides, I guess that accessing the io context information (such as
> > ioprio) of a request through elevator-specific private structures is not
> > something we want virtio_blk (or future users) to do.
> 
> The only semantic I assumed was "higher is better".  The server (ie. host) can 
> really only use the information to schedule between I/Os for that particular 
> guest anyway.
> 
> But it sounds like I should be passing "0" in there unconditionally until the 
> kernel semantics are sorted out and I can do something more intelligent?  I 
> haven't checked, but I assume that's actually what's happening at the moment 
> (the field is zero)?
Yes, with the current implementation the field is always zero, but
things might change. Instead of passing 0 unconditionally I think we
could use a function that extracts/calculates the ioprio of requests.
The patch I sent you yesterday is the first step in that direction. Is
this a valid approach for you?

