Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYAYQSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYAYQSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYAYQRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:17:52 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:62256 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYAYQRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:17:51 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: lockdep warning with LTP dio test (v2.6.24-rc6-125-g5356f66)
Date: Fri, 25 Jan 2008 11:16:13 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Zach Brown <zach.brown@oracle.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, ext3-users@redhat.com,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org
References: <200712242302.lBON2O8s011190@agora.fsl.cs.sunysb.edu> <20080114131454.37eb7c12@think.oraclecorp.com> <20080125160931.GC1767@duck.suse.cz>
In-Reply-To: <20080125160931.GC1767@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251116.13690.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008, Jan Kara wrote:

> > If ext3's DIO code only touches transactions in get_block, then it can
> > violate data=ordered rules.  Basically the transaction that allocates
> > the blocks might commit before the DIO code gets around to writing them.
> >
> > A crash in the wrong place will expose stale data on disk.
>
>   Hmm, I've looked at it and I don't think so - look at the rationale in
> the patch below... That patch should fix the lock-inversion problem (at
> least I see no lockdep warnings on my test machine).
>

Ah ok, when I was looking at this I was allowing holes to get filled without 
falling back to buffered.  But, with the orphan inode entry protecting things 
I see how you're safe with this patch.

-chris
