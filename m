Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbYEOSQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbYEOSQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYEOSQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:16:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44797 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYEOSQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:16:38 -0400
Date: Thu, 15 May 2008 20:17:37 +0200
From: Pavel Machek <pavel@suse.cz>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Subject: Re: 2.6.26-rc1: warnings from sysfs, bluetooth related
Message-ID: <20080515181737.GC21623@elf.ucw.cz>
References: <20080511161930.GA2179@elf.ucw.cz> <a8e1da0805111905y49239cb7ja13f8e1c685bf6a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0805111905y49239cb7ja13f8e1c685bf6a9@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'm getting these from rfcomm...
> 
> 
> Are you sure it's a regression?

No, I'm not sure it is an regression. I have not seen it in a while,
and I seen it on -rc1. It does not seem to be too repeatable.

> Dont know if it's same bug as BUG 10341.  I just describe the problem
> in bug 10341:
> 
> While a rfcomm device is opened more than once, the BUG 10341 can be triggered.
> 
> rfcomm dev reference will be held for every rfcomm_tty_open, but release_dev
>  will hangup the tty and release the dev number for free use without
> judge the dev->opened.
> 
> rfcomm_dev_state_change and rfcomm_tty_hangup could del the rfcomm dev
> as well,  the problem is similar as above.
> 
> If the create_dev called before the last tty_close,  sysfs will
> warning and create will fail.
> 
> I have a patch which don't hold the dev reference in rfcomm_tty_open,
> but it need some review and test.
> 
> please see:
> http://bugzilla.kernel.org/attachment.cgi?id=15746
> 
> Marcel, do you have idea about this? or other solution?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
