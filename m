Return-Path: <linux-kernel-owner+w=401wt.eu-S1761790AbYBRWT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761790AbYBRWT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYBRWTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:19:52 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60867 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752808AbYBRWTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:19:51 -0500
Date: Mon, 18 Feb 2008 23:20:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: Status of storage autosuspend
Message-ID: <20080218222014.GB31201@elf.ucw.cz>
References: <20080218202749.GA2656@elf.ucw.cz> <Pine.LNX.4.44L0.0802181530330.31135-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802181530330.31135-100000@netrider.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > What is the status of USB storage/SCSI autosuspend patches? They work
> > nicely here ;-).
> 
> I could submit them, but there is one outstanding problem I would like
> to solve first.  Maybe you can suggest a solution.
> 
> The problem is how to handle SG_IOCTL calls.  It seems that the only
> safe thing to do is to force an autoresume and prevent the device from
> autosuspending until the device file is closed.  Unfortunately the
> SG_IOCTL stuff is all handled inside the block layer, and there's no
> apparent way (other than some dreadful hack) of passing the necessary
> information down to the SCSI layer.

Hmm...

> Should we ignore this issue and submit the patches anyway?

I think you should. "Easy" (and clean) solution to that issue is to
just return -EPERM from SG_IOCTL if autosuspend is configured in ;-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
