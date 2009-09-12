Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZILDZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZILDZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 23:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZILDZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 23:25:19 -0400
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:21865 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753681AbZILDZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 23:25:18 -0400
X-Yahoo-SMTP: RrAacJSswBBjW0Obe5dhTHj7mfiuboERhd4hX4HvWHq2RmBoxiTUVqFaT6p3
X-YMail-OSG: FBDQUk0VM1ltR4kMh55Yz6p3ZSAv4i8C6R4qQOKCovMavbfcAr5DnO1Wync_QsGshX6oURBOpYXf8I594RDFHZfKZVgeC5umecrCVo4_I9suf7r9rRTYr8CtDk_5QBjbQqMBsBLTofS6F33vQvG0rpzsVt.Oinu7EELbbvQH8xFwD0iy6G.LAQW0s5U3rXHMMiJSF_BWDhbL2rm1KtIgrhN..Hei_t668V.DiCYPswUTBFXRureqJj1YoLVnNbXdreQyZWO9GZKzi_SBbC6joQIYJqweGdQ-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC PATCH 0/19] A kernel-level configfs enabled generic
	target engine for Linux v2.6.32
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Joel Becker <joel.becker@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Christoph Hellwig <hch@lst.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Florian Haas <florian.haas@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
In-Reply-To: <1252725468.28368.54.camel@desktop>
References: <1252720508.2067.196.camel@haakon2.linux-iscsi.org>
	 <1252723060.28368.48.camel@desktop>
	 <1252724884.2067.251.camel@haakon2.linux-iscsi.org>
	 <1252725468.28368.54.camel@desktop>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 20:24:57 -0700
Message-Id: <1252725897.2067.255.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 20:17 -0700, Daniel Walker wrote:
> On Fri, 2009-09-11 at 20:08 -0700, Nicholas A. Bellinger wrote:
> 
> 
> > 
> > Ok, I will have a look at converting the HBA semaphore to a mutex in
> > patch 5, and use some single use waitqueues in patch 16.  Btw, the ones
> > using init_MUTEX_LOCKED() in the latter source file are being used when
> > shutting down target_core_mod allocated kernel threads to sychronize
> > between the stopping processing threads and configfs process context
> > that waitqueues would work better for.  Thanks for pointing this out!
> 
> You could also use completions in patch 16 if the waitqueues turn out to
> be not what your looking for. Completion can sometimes be a find&replace
> substitute for the locked semaphores.

Sorry, include/linux/complete.h is what I was thinking here too..

> 
> 
> > I was thinking about going through the typedefs with a sed chainsaw, but
> > I decided against for this TCM patch series because it makes keeping
> > backward ports to <= v2.6.31 slightly easier to maintain for me for the
> > current users of LIO kernel code.
> > 
> > However, I have been starting to not use typedef for the newest ALUA and
> > pieces of PR code, and I would be happy to have another look at typedef
> > style comments on this once the other larger interest items are on the
> > way to being resolved.
> 
> It's up to you, but you should schedule the typedefs for removal at some
> point.
> 

Ok, I will do that.

Many thanks for your most valuable of time,

--nab

> Daniel
> 

