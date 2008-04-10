Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbYDJOpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbYDJOpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbYDJOpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:45:24 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:40851 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756143AbYDJOpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:45:23 -0400
X-Greylist: delayed 2035 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2008 10:45:23 EDT
Date: Thu, 10 Apr 2008 16:11:24 +0200
From: Martin Mares <mj@ucw.cz>
To: Michal Hocko <mhocko@suse.cz>
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <mj+md-20080410.140857.3331.nikam@ucw.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804101555.58643.mhocko@suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> [*] file_pos_{read,write} (fs/read_write.c) are not called under lock (in 
> sys_read, sys_write, ...), so even if f_pos is written atomically, you will 
> be able to get races when accessing shared descriptor from different threads.

There are however cases when such behavior is perfectly valid: For example
you can have a file of records of a fixed size, whose order does not matter.
Then multiple processes can produce the records in parallel, sharing
a single fd.

> I think that POSIX states, that behavior is undefined under these conditions.

Do you have a pointer to that?

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Mr. Worf, scan that ship."  "Aye, Captain... 600 DPI?
