Return-Path: <linux-kernel-owner+w=401wt.eu-S1765302AbYAaGXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765302AbYAaGXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 01:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763869AbYAaGXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 01:23:40 -0500
Received: from [212.12.190.218] ([212.12.190.218]:45103 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752306AbYAaGXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 01:23:39 -0500
From: Al Boldi <a1426z@gawab.com>
To: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Thu, 31 Jan 2008 09:20:36 +0300
User-Agent: KMail/1.5
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
       Chris Snook <csnook@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <200801300929.21778.chris.mason@oracle.com> <20080131003231.GK23836@webber.adilger.int>
In-Reply-To: <20080131003231.GK23836@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801310920.36383.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> On Wednesday 30 January 2008, Al Boldi wrote:
> > And, a quick test of successive 1sec delayed syncs shows no hangs until
> > about 1 minute (~180mb) of db-writeout activity, when the sync abruptly
> > hangs for minutes on end, and io-wait shows almost 100%.
>
> How large is the journal in this filesystem?  You can check via
> "debugfs -R 'stat <8>' /dev/XXX".

32mb.

> Is this affected by increasing
> the journal size?  You can set the journal size via "mke2fs -J size=400"
> at format time, or on an unmounted filesystem by running
> "tune2fs -O ^has_journal /dev/XXX" then "tune2fs -J size=400 /dev/XXX".

Setting size=400 doesn't help, nor does size=4.

> I suspect that the stall is caused by the journal filling up, and then
> waiting while the entire journal is checkpointed back to the filesystem
> before the next transaction can start.
>
> It is possible to improve this behaviour in JBD by reducing the amount
> of space that is cleared if the journal becomes "full", and also doing
> journal checkpointing before it becomes full.  While that may reduce
> performance a small amount, it would help avoid such huge latency
> problems. I believe we have such a patch in one of the Lustre branches
> already, and while I'm not sure what kernel it is for the JBD code rarely
> changes much....

The big difference between ordered and writeback is that once the slowdown 
starts, ordered goes into ~100% iowait, whereas writeback continues 100% 
user.


Thanks!

--
Al

