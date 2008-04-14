Return-Path: <linux-kernel-owner+w=401wt.eu-S1762314AbYDNRGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbYDNRGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759099AbYDNRGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:06:17 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58188 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071AbYDNRGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:06:14 -0400
Date: Mon, 14 Apr 2008 13:06:13 -0400
To: Jan Kara <jack@suse.cz>
Cc: Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080414170613.GI7385@csclub.uwaterloo.ca>
References: <ah5tY-3lR-7@gated-at.bofh.it> <ah5DA-3X9-9@gated-at.bofh.it> <ah5X5-4tl-13@gated-at.bofh.it> <ah66A-4Nk-7@gated-at.bofh.it> <ah7vN-7Wz-9@gated-at.bofh.it> <E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org> <20080411135544.GG2160@csclub.uwaterloo.ca> <20080414162031.GD15824@duck.suse.cz> <20080414162202.GB7387@csclub.uwaterloo.ca> <20080414165354.GF15824@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414165354.GF15824@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 06:53:54PM +0200, Jan Kara wrote:
>   Well, but imagine you have a file /proc/my_secret_file from which you
> are able to read from position A:a and B:b but not from position
> A:b. Concievably, checks for the file position could be bypassed because of
> this race... I know this is kind of dumb example but I can imagine someone
> can eventually find something like this. So I guess one spin lock/unlock
> pair is a price worth paying in the callpath which is quite long anyway.

But only two threads within the process can read from the filehandle and
hence the process would be doing locking.  And external attacker can't
break the internal locking of the process between the threads, and even
if you do open the file in /proc that the process is using, being and
external process you would have your own file handle and hence your own
file position since you aren't part of that process.

-- 
Len Sorensen
