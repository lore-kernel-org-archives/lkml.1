Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZLSNht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZLSNht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 08:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZLSNhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 08:37:48 -0500
Received: from mail.nec-labs.com ([138.15.200.209]:41558 "EHLO
	mail.nec-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZLSNhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 08:37:47 -0500
Subject: Re: [PATCH] improve the performance of large sequential write NFS
	workloads
From: Steve Rago <sar@nec-labs.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, Wu Fengguang <fengguang.wu@intel.com>,
       "jens.axboe" <jens.axboe@oracle.com>
In-Reply-To: <20091219090824.1bc4a1c8@infradead.org>
References: <1261015420.1947.54.camel@serenity>
	 <1261037877.27920.36.camel@laptop> <1261164799.1947.123.camel@serenity>
	 <20091218194129.GB6153@elte.hu> <1261171211.1947.135.camel@serenity>
	 <20091219090824.1bc4a1c8@infradead.org>
Content-Type: text/plain
Date: Sat, 19 Dec 2009 08:37:35 -0500
Message-Id: <1261229855.1947.155.camel@serenity>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2009-12-19 at 09:08 +0100, Arjan van de Ven wrote:
> On Fri, 18 Dec 2009 16:20:11 -0500
> Steve Rago <sar@nec-labs.com> wrote:
> 
> > 
> > I don't disagree, but "that's not what we do" hardly provides insight
> > into making the judgment call.  In this case, the variety of
> > combinations of NFS server speed, NFS client speed, transmission link
> > speed, client memory size, and server memory size argues for a tunable
> > parameter, because one value probably won't work well in all
> > combinations.  Making it change dynamically based on these parameters
> > is more complicated than these circumstances call for, IMHO.
> 
> 
> if you as the expert do not know how to tune this... how is a sysadmin
> supposed to know better?
> 

I did not say I didn't know how to tune it.  I said you put the tunable
parameter in as a compromise to doing something far more complex.  You
then adjust the value according to various workloads (in this case,
iozone or something that more closely resembles your application).  The
same way I figure out how man NFSD processes to configure; the same way
I figure out acceptable values for dirty_ratio and
dirty_background_ratio.  The code has a reasonably conservative default,
and people can adjust it if their circumstances differ such that the
default doesn't provide acceptable results.

Steve


