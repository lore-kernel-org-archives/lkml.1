Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZILDIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZILDIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 23:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbZILDIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 23:08:18 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:29123 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753018AbZILDIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 23:08:17 -0400
X-YMail-OSG: d1_UvdwVM1nFvsNDVIiXpk2luQaTdlGSW_eD3tGcKQS3Vk.iGvJNFy1hPFy5C0HunLkd917p22hJUJnIwl.QZ2NuwA5rA6rvRsaYe0.GQsD1Hii2rB1Os7pDK.roJjqHaDsn1jRdOOepkR93kktmvwcdL.eHD4psJOlU72.md.pspgdZ70MO6gcxgriqFDVXdpEuWXG93kEFq7MPnGNBNg--
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
In-Reply-To: <1252723060.28368.48.camel@desktop>
References: <1252720508.2067.196.camel@haakon2.linux-iscsi.org>
	 <1252723060.28368.48.camel@desktop>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 20:08:04 -0700
Message-Id: <1252724884.2067.251.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 19:37 -0700, Daniel Walker wrote:
> On Fri, 2009-09-11 at 18:55 -0700, Nicholas A. Bellinger wrote:
> > There is cleanup work continuing to make the TCM code to use
> > dprintk(),
> > and some include cleanups, and other minor fixes.  The code has also
> > been run through checkpatch again since the posting in April, and all
> > errors have been removed, with the exception of one ConfigFS macro
> > define triggering a checkpatch false positive.
> 

Greetings Daniel,

> 
> One show stopping issue is that your adding new semaphore usage in patch
> 5 and 16 (and in 16 it's a LOCKED one wtf!!). Which you should not be
> doing .. You need to really evaluate the warnings from checkpatch, cause
> those still have meaning.. 
> 

Ok, I will have a look at converting the HBA semaphore to a mutex in
patch 5, and use some single use waitqueues in patch 16.  Btw, the ones
using init_MUTEX_LOCKED() in the latter source file are being used when
shutting down target_core_mod allocated kernel threads to sychronize
between the stopping processing threads and configfs process context
that waitqueues would work better for.  Thanks for pointing this out!

> It's basically telling you what you should be doing in the warnings..
> For instance, don't add new semaphore usage, and it tells you what you
> need to be using in place of them..

Ok, so I will also do the struct sempahore -> struct mutex conversion
where it makes sense to protect lists and see about the rest..

>  Also typedefs are frowned upon, so
> you could remove those..
> 

I was thinking about going through the typedefs with a sed chainsaw, but
I decided against for this TCM patch series because it makes keeping
backward ports to <= v2.6.31 slightly easier to maintain for me for the
current users of LIO kernel code.

However, I have been starting to not use typedef for the newest ALUA and
pieces of PR code, and I would be happy to have another look at typedef
style comments on this once the other larger interest items are on the
way to being resolved.

Thanks!

--nab

> Daniel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

