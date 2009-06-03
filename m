Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZFCT61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZFCT61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZFCT6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:58:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44772 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbZFCT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:58:05 -0400
Date: Wed, 3 Jun 2009 21:58:06 +0200
From: Jan Kara <jack@suse.cz>
To: Diego Calleja <diegocg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Performance regressions in 2.6.30-rc7?
Message-ID: <20090603195806.GA9571@atrey.karlin.mff.cuni.cz>
References: <200905282249.28592.diegocg@gmail.com> <20090529210718.bef7a9c1.akpm@linux-foundation.org> <200905301851.47708.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905301851.47708.diegocg@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sábado 30 Mayo 2009 06:07:18 Andrew Morton escribió:
> > Those regressions are huge.  They appear to be on compute-intensive
> > workloads too.
> > 
> > I wonder if some expensive debugging option turned itself on or
> > something silly like that.
> 
> They use the vanilla kernels that ubuntu ship with their own configs,
> so they shouldn't be using any expensive debugging option.
> 
> I've run myself two of those tests (I've not tested gnupg as I'm
> allergic to it). I can't reproduce any regression with 7zip, I'm however
> able to reproduce the regression in tiobench write latency, using 32
> threads and 64 MB block size (--threads 32 --block 65536). I used ext4
> (phoronix uses ext3).
> 
> 
> Random Writes
>                               File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 2.6.29                        2000  65536  32   24.16 107.2%     0.051        0.21   0.00000  0.00000    23
> 
> Random Writes
>                               File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 2.6.30-rc7-00149-g3218911     2000  65536  32   23.06 178.4%     0.711      164.72   0.00000  0.00000    13
  Hmm, also the CPU utilization seems to be much higher with comparable
(in fact slightly lower) throughput. Would it be possible to get
oprofile from the run on 2.6.30 and 2.6.29?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
