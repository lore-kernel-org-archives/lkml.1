Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYEFGyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYEFGyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYEFGyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:54:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbYEFGyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:54:08 -0400
From: Neil Brown <neilb@suse.de>
To: Mike Snitzer <snitzer@gmail.com>
Date: Tue, 6 May 2008 16:53:58 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18464.134.236488.251879@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       paul.clements@steeleye.com
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
In-Reply-To: message from Mike Snitzer on Wednesday April 2
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday April 2, snitzer@gmail.com wrote:
> resync via bitmap if faulty's events+1 == bitmap's events_cleared
> 
> For more background please see:
> http://marc.info/?l=linux-raid&m=120703208715865&w=2
> 
> Without this change validate_super() will prevent the previously faulty
> member from recovering via bitmap, e.g.:

I can't help thinking that you are misinterpreting something.  I don't
think there is a clean->dirty transition happening here.
You could confirm this by using --examine on both devices after the
messy shutdown and before re-assembling the array.

Even allowing for that possible confusion, I cannot quite see what is
going on.
It is fairly clear from the event counts that the NBD device is marked
clean, but if this is happening at array-shutdown time, I cannot see
why md would try to write to the NBD device and thereby detect an
error...

Do you have an internal bitmap or a bitmap in an external file?

In general, I would not like to make decisions based on the
oddness/evenness of the event counter.  I consider that to be an
internal implementation detail.  I am happy to make decisions based on
a difference-of-1.  I need to understand the big picture first though.

NeilBrown
