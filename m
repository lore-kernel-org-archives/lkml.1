Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbXLQRPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbXLQRPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbXLQRPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:15:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60545 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbXLQRPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:15:33 -0500
Date: Mon, 17 Dec 2007 18:15:32 +0100
From: Jan Kara <jack@suse.cz>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: swapping in 2.6.24-rc5-git3
Message-ID: <20071217171532.GK6979@atrey.karlin.mff.cuni.cz>
References: <20071217131726.GA14091@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217131726.GA14091@ics.muni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> does /proc/sys/vm/swappiness still work as expected? 
> # /proc/sys/vm# cat swappiness 
> 0
  I think yes. 0 swappiness doesn't mean "no swapping at all". From the
code in shrink_active_list() it seems that it just decreases likeliness
of removing pages of mmaped files (i.e., also executables loaded in memory).

> but scp-ing 2GB file causes many processes are swapped out due to increase of
> the file cache size. Why? This is totally catastrophic behaviour on the desktop.
  Yes, that's quite unpleasant. How much memory do you have? If you have
some time, you can try playing with the code in mm/vmscan.c to find out
what's happening in your case (putting some debugging output in
shrink_active_list() etc...

> Is there a way to avoid it except turning off the swap?
  Currently, I'm not aware of any way...

										Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
