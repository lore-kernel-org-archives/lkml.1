Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZFWReg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZFWReg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZFWRe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:34:29 -0400
Received: from mta.netezza.com ([12.148.248.132]:59711 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbZFWRe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:34:28 -0400
Subject: Re: [PATCH] coredump: Retry writes where appropriate
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090604171458.F0DC7FC3C3@magilla.sf.frob.com>
References: <20090601161234.GA10486@redhat.com>
	 <20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
	 <20090601171119.GA13970@redhat.com>
	 <20090601184608.6379440c@lxorguk.ukuu.org.uk>
	 <20090601182305.GA16372@redhat.com>
	 <20090601203845.B010DFC3C7@magilla.sf.frob.com>
	 <20090601223241.GA26788@redhat.com>
	 <20090601230210.C0B15FC3C7@magilla.sf.frob.com>
	 <20090602000850.GA31064@redhat.com>
	 <20090603070939.4E31CFC333@magilla.sf.frob.com>
	 <20090604031544.GA23930@redhat.com>
	 <20090604171458.F0DC7FC3C3@magilla.sf.frob.com>
Content-Type: text/plain
Organization: GNU's Not Unix!
Date: Tue, 23 Jun 2009 13:31:18 -0400
Message-Id: <1245778278.9022.21.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2009 17:31:19.0467 (UTC) FILETIME=[6B68CFB0:01C9F428]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 10:14 -0700, Roland McGrath wrote:
> > Fortunately, this doesn't look hard. Whatever we do, we should modify
> > dump_write/seek to check fatal_signal_pending() anyway. Because we can't
> > know if f_ops->write() pays attention to signals. 
> 
> Yes, that sounds fine.
> 
> > This means we can just add try_to_freeze().
> 
> Right.
> 
> > As for exit_mm(), we can use freezer_do_not_count() + freezer_count()
> > around the "for (;;)" loop.
> 
> Ah yes, sure.

Hi Oleg;

Did you have any more time to look into this?  I'm currently using my
patch and it's OK for my purposes but I'll be happy to test any proposal
you come up with, if you like, so I can drop my patch in the future.

Let me know, thanks!

