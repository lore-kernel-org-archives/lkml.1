Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab0BKXKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:10:32 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:51741 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757197Ab0BKXKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:10:30 -0500
From: Michael Poole <mdpoole@troilus.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid-magicmouse: Coding style and probe failure fixes.
References: <87y6j2eeqv.fsf_-_@troilus.org> <87pr4eeemz.fsf_-_@troilus.org>
	<20100210182024.GA29610@core.coreip.homeip.net>
	<873a18e3qu.fsf_-_@troilus.org>
	<alpine.LNX.2.00.1002111124030.30967@pobox.suse.cz>
Date: Thu, 11 Feb 2010 18:10:25 -0500
In-Reply-To: <alpine.LNX.2.00.1002111124030.30967@pobox.suse.cz> (Jiri
	Kosina's message of "Thu, 11 Feb 2010 11:26:22 +0100 (CET)")
Message-ID: <87r5orcqse.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina writes:

> On Thu, 11 Feb 2010, Michael Poole wrote:
>
>> I haven't had a chance to run-test these changes yet -- hid/for-next
>> causes corrupt X display on my laptop, whereas v2.6.33-rc6 and -rc7 are
>> fine; 
>
> That's indeed quite strange. I'd be curious to see the result of the 
> bisection, thanks a lot for doing this.

The problem was introduced by 859ddf0 and reverted in 6f14a66 (both only
touching lib/idr.c).  You just happened to merge from master during an
unfortunate window :)

Cherry-picking the revert (6f14a66) on top of commit 093657 (details
shown below for reference) yields a working kernel with a working Magic
Mouse driver.  I expect that merging the rest of master would also work.

commit 09365737da8b3af76abd9d811d435d3ce379903a
Merge: 1b97e37 71b38bd
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Feb 11 11:22:52 2010 +0100

    Merge branch 'apple_magic_mouse' into for-next

Michael Poole
