Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbYAKBhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbYAKBhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 20:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYAKBhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 20:37:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbYAKBhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 20:37:32 -0500
From: Neil Brown <neilb@suse.de>
To: Jeff Layton <jlayton@redhat.com>
Date: Fri, 11 Jan 2008 12:37:24 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18310.51284.272147.137400@notabene.brown>
Cc: akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Intro: convert lockd to kthread and fix use-after-free (try #7)
In-Reply-To: message from Jeff Layton on Thursday January 10
References: <1199988096-19700-1-git-send-email-jlayton@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday January 10, jlayton@redhat.com wrote:
> This is the seventh patchset to fix the use-after-free problem in lockd
 ....

This patch set looks good now.  I'm happy to give it a 

  Reviewed-by: NeilBrown <neilb@suse.de>

Two remaining issues that I would like to see address, but don't
necessarily need to be part of this set, are:

 1/ When the last nfsd thread dies, lockd should drop all locks, even
    if there are active nfs mounts.
    One approach might be:
      export nlmsvc_invalidate_all
      call it from nfsd_last_thread
      worry about how to change grace_period_expire.

 2/ get rid of svc_wake_up and ->b_daemon
    Maybe change b_daemon to b_rqstp and just call
	wake_up(&block->b_rqstp->rq_wait)

Thanks,
NeilBrown

      
