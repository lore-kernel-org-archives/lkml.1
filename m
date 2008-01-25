Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYAYPgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYAYPgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYAYPgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:36:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34472 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYAYPgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:36:35 -0500
Date: Fri, 25 Jan 2008 16:36:34 +0100
From: Jan Kara <jack@suse.cz>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Message-ID: <20080125153634.GG28856@atrey.karlin.mff.cuni.cz>
References: <200801242336.00340.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801242336.00340.a1426z@gawab.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Greetings!
> 
> data=ordered mode has proven reliable over the years, and it does this by 
> ordering filedata flushes before metadata flushes.  But this sometimes 
> causes contention in the order of a 10x slowdown for certain apps, either 
> due to the misuse of fsync or due to inherent behaviour like db's, as well 
> as inherent starvation issues exposed by the data=ordered mode.
> 
> data=writeback mode alleviates data=order mode slowdowns, but only works 
> per-mount and is too dangerous to run as a default mode.
> 
> This RFC proposes to introduce a tunable which allows to disable fsync and 
> changes ordered into writeback writeout on a per-process basis like this:
> 
>       echo 1 > /proc/`pidof process`/softsync
  I guess disabling fsync() was already commented on enough. Regarding
switching to writeback mode on per-process basis - not easily possible
because sometimes data is not written out by the process which stored
them (think of mmaped file). And in case of DB, they use direct-io
anyway most of the time so they don't care about journaling mode anyway.
  But as Diego wrote, there is definitely some room for improvement in
current data=ordered mode so the difference shouldn't be as big in the
end.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
