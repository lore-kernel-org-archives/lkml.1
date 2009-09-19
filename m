Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbZISCHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbZISCHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 22:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbZISCHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 22:07:09 -0400
Received: from n23a.bullet.mail.mud.yahoo.com ([68.142.207.189]:43844 "HELO
	n23a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754651AbZISCHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 22:07:07 -0400
X-Yahoo-Newman-Id: 928013.17147.bm@omp404.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: hdAYKN0VM1nIxN5TymwwXWmMJ2n7r20r_wPy.3pQObvRuNIGWmWFZLKBGcPBDoDvvlhmLxW4j54qdELvUJz6kEeWmqfD1hAmMp3AuoNBWotPnG_xiIzI0bAlnV9VLh9xrf7ogUzmXjtWDlRmPx0Lf2Z0_ZIo9.WZpChAyh_Ev.aFGisK5I5Krtxbypk72Mj0Vh4KwLmQWqLa2Qz2ru9NFN1J299qPGEeYlVBq1X1ACU04KoVvD8JB74_YsyjkaL5TnPLs7V.qmGOEvoz4poylRlLLg7XrSmr3lOQA_55NZPkn4_nHrt5OM7WpEVxetRoMc9tkWz7jHyH8wSG5.zOJzZPMqQWdjqCgPO.TA--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC v2 PATCH 0/19] A kernel-level configfs enabled generic
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
       Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
In-Reply-To: <1253322925.6699.8.camel@desktop>
References: <1253311656.4498.143.camel@haakon2.linux-iscsi.org>
	 <1253322925.6699.8.camel@desktop>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 19:07:08 -0700
Message-Id: <1253326028.4498.194.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 18:15 -0700, Daniel Walker wrote:
> On Fri, 2009-09-18 at 15:07 -0700, Nicholas A. Bellinger wrote:
> > Greetings all,
> > 
> > This is the second round of request for comments for TCM/ConfigFS v3.2
> > from lio-core-2.6.git.
> > Thanks to the folks who made comments, and I again invite people to
> > take a look and make
> > recommendations on how the code can be futher improved to use the best
> > available upstream
> > interfaces.
> 
> There are still a couple of minor checkpatch errors in the series, but
> it's nothing you would need to resubmit because of ..
> 
> In patch 2 the following are fixable,
> 
> ERROR: return is not a function, parentheses are not required
> #3401: FILE: include/target/configfs_macros.h:104:
> +       return((ci) ? container_of(to_config_group(ci), struct _item,   \
> 
> ERROR: trailing whitespace
> #3438: FILE: include/target/configfs_macros.h:141:
> +CONFIGFS_EATTR_OPS_STORE(_name, _item);^I$
> 
> 
> and in Patch 18, and 19 there are a couple more whitespace related
> errors you could fix..
> 

Ok, commited these checkpatch fixes:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=65808529e0ed76308842c87faccf4526fa8bb13d

Also, it looks like configfs_macros.h is triggering the same checkpatch
false-positive as target_core_configfs.c:

configfs_macros.h:138: ERROR: Macros with multiple statements should be enclosed in a do - while loop
configfs_macros.h:143: ERROR: Macros with multiple statements should be enclosed in a do - while loop

This is the case where macros with multiple statements exist containing
function defintions, which obviously cannot be included in a do {} while
loop.

Thanks Daniel,

--nab


> Daniel
> 


