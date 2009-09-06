Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbZIFF1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbZIFF1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 01:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZIFF1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 01:27:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52421 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZIFF1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 01:27:21 -0400
Date: Sun, 6 Sep 2009 07:27:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Norbert van Bolhuis <nvbolhuis@aimvalley.nl>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: CONFIG_NO_HZ could cause software timeouts
Message-ID: <20090906052717.GC1324@ucw.cz>
References: <4A9F9F64.5080305@aimvalley.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9F9F64.5080305@aimvalley.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-09-03 12:50:12, Norbert van Bolhuis wrote:
>
> The problem occurs when e.g. drivers use time_after(jiffes, timeout).
>
> CONFIG_NO_HZ could make jiffies advance by more than 1.
> This is done by: tick_nohz_update_jiffies->tick_do_update_jiffies64->do_timer

jiffies really should be up-to-date as long as you are running
anything else than idle loop. If not, that's a bug ... and nasty one.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
