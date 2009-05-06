Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbZEFJyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbZEFJyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZEFJyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:54:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46677 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbZEFJx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:53:59 -0400
Date: Wed, 6 May 2009 11:53:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] blktrace: correct remap names
Message-ID: <20090506095343.GA15323@elte.hu>
References: <20090430133627.D217.A69D9226@jp.fujitsu.com> <49F9D82D.50901@hp.com> <49F9D906.40300@hp.com> <49FE8165.80709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FE8165.80709@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> > Subject: [PATCH] blktrace: correct remap names
> > 
> > This attempts to clarify names utilized during block I/O remap operations
> > (partition, volume manager). It correctly matches up the /from/ information for both device & sector. This takes in the concept from osaki Motohiro and extends it to include better naming for the "device_from" field.
> > 
> 
> I also noticed this..
> 
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> > ---
> >  include/linux/blktrace_api.h |    4 ++--
> >  include/trace/block.h        |    4 ++--
> >  kernel/trace/blktrace.c      |   21 +++++++++++----------
> >  3 files changed, 15 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
> > index d960889..da1a14e 100644
> > --- a/include/linux/blktrace_api.h
> > +++ b/include/linux/blktrace_api.h
> > @@ -116,9 +116,9 @@ struct blk_io_trace {
> >   * The remap event
> >   */
> >  struct blk_io_trace_remap {
> > -	__be32 device;
> >  	__be32 device_from;
> > -	__be64 sector;
> > +	__be32 device_to;
> > +	__be64 sector_from;
> >  };
> >  
> 
> If we are really fine with this change, then:
> 
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

is it acceptable to break the sector output ordering of all past 
blktrace+blkparse binaries, as far as remap events go?

	Ingo
