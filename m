Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbYDJP27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbYDJP27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbYDJP2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:28:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45528 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077AbYDJP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:28:48 -0400
Date: Thu, 10 Apr 2008 17:28:46 +0200
From: Jan Kara <jack@suse.cz>
To: Martin Mares <mj@ucw.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080410152846.GG6725@atrey.karlin.mff.cuni.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz> <mj+md-20080410.140857.3331.nikam@ucw.cz> <20080410151406.GA17051@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410151406.GA17051@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Martin Mares wrote:
> > > [*] file_pos_{read,write} (fs/read_write.c) are not called under
> > > lock (in sys_read, sys_write, ...), so even if f_pos is written
> > > atomically, you will be able to get races when accessing shared
> > > descriptor from different threads.
> > 
> > There are however cases when such behavior is perfectly valid: For example
> > you can have a file of records of a fixed size, whose order does not matter.
> > Then multiple processes can produce the records in parallel, sharing
> > a single fd.
> 
> A rather more common thing:
> 
> Does this problem apply when appending lines or records to a log file,
> with or without O_APPEND?
  O_APPEND works correctly in all cases (it ignores f_pos in the
descriptor). Without O_APPEND you can hit the race (but I'd like to see
a sensible use case of this ;).

> Also, can this problem affect programs doing concurrent reads/writes
> using pread/pwrite (or the AIO equivalents)?
  As Matthew said, pread/pwrite are safe, parallel read can hit the race,
write was described above...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
