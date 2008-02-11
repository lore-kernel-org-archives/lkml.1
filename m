Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYBKF1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYBKF1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYBKF1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:27:09 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:40658 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750906AbYBKF1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:27:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xa6DEf5fZt2GxXBZZvgp7NOEvJwydTqkmZJw8uXHHgevAV3xOG97Ys6hCijMzb6L3IP1ylwvbCZjEK6iA41gS3jS3BsuupR2wAYpxrH5SLXwU7NEUNmlrXz/aNdrk6Ge7wirDb0tvnfRrp69/IY0LIQc2YJK7VBvUksTKBTQptc=  ;
X-YMail-OSG: MoR721gVM1kMpKPucuUOX_kHOfMR9BYTsQsRJUNNClm_onaSBubDSBxoiDTOwPMmq2fHtmmg3kMFjjTPaq3FRmE6jxqVifuMqzfgJTClEql.Wb.v_6E-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Oops report for the week upto Feb 10th 2008
Date: Mon, 11 Feb 2008 16:26:51 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <47AF9867.6050902@linux.intel.com>
In-Reply-To: <47AF9867.6050902@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111626.51241.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 11:35, Arjan van de Ven wrote:
> The http://www.kerneloops.org website collects kernel oops and
> warning reports from various mailing lists and bugzillas as well as
> with a client users can install to auto-submit oopses.
> Below is a top 10 list of the oopses/backtraces collected in the last 7
> days. (Reports prior to 2.6.23 have been omitted in collecting the top 10)
>
> This week, a total of 323 oopses and warnings have been reported,
> compared to 110 reports in the previous week.
>
> (This sharp increase is due to Fedora 9 alpha shipping the oops data
> collection client in the default install, giving us much wider coverage
> in the issues that actual users hit; many thanks to the Fedora project
> for this)
>
> With the 2.6.25-rc1 release out, this will be the last report that includes
> 2.6.23; future reports will only include issues from 2.6.24 and later.
>
>
> Rank 1: set_dentry_child_flags
> 	WARN_ON at fs/inotify.c:172 set_dentry_child_flags
> 	Reported 93 times (116 total reports)
> 	This is a user triggered WARN_ON in inotify. Sadly inotify seems to be
> unmaintained. More info:
> http://www.kerneloops.org/search.php?search=set_dentry_child_flags

I was never able to trigger this or get anyone to reliably trigger it with
a debug patch in. Which is why it has taken so long to fix. It looks like
kde4 is triggering this big rash of new reports.

Anyway, I have fixed a race or two and removed that warning code (which was
also a little racy). So I think that should be OK.


> Rank 9: mark_buffer_dirty
> 	WARN_ON at fs/buffer.c:1169
> 	This indicates that a non-uptodate buffer is marked dirty.
> 	This can lead to data corruption!
> 	Reported 5 times (12 total reports) - Only seen since 2.6.24-rc6
> 	Usually happens during umount()
> 	More info: http://www.kerneloops.org/search.php?search=mark_buffer_dirty

That's interesting.
