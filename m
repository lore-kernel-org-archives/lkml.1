Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYCISts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYCISts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYCIStk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:49:40 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:58520 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbYCIStk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:49:40 -0400
Date: Sun, 9 Mar 2008 19:49:36 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Eric Sandeen <sandeen@sandeen.net>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc hangs
In-Reply-To: <47D42AD6.10500@sandeen.net>
Message-ID: <alpine.DEB.1.00.0803091934090.5349@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de> <alpine.DEB.1.00.0803090658040.5349@sheep.housecafe.de>
 <47D413FA.50602@sandeen.net> <alpine.DEB.1.00.0803091858480.5349@sheep.housecafe.de> <47D42AD6.10500@sandeen.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Eric Sandeen wrote:
> I meant the test you were using to determine "good" from "bad" - I guess
> it was "boot up and do IO for a while to see if it hangs"

Maybe I was too confusing, let me try again:

* 2.6.24.1 was running fine for weeks (and is now)
* 2.6.25-rc3, -rc4 comes with system hang. Trying to bisect it failed
   at a really early stage:

  [check out current -git, 2.6.25-rc4)
  $ git bisect start
  $ git bisect bad          # because I know, that current -git is bad
  $ git bisect good v2.6.24 # because I know 2.6.24 is good
  [ compiling, and first reboot]
  -> failed, because hard lockup.

After rebooting to a working kernel I can now do either:

  1) mark the current one as "bad", solely on the fact that "it does not
    boot" and is "bad" per se, ignoring the fact that if the box *had*
    booted, the system hang *perhaps* did not occur. IOW, I'm marking
    it "bad" because of a totally different issue.

  2) although booting failed, I still mark it "good", which means I'm
    literally *guessing* that this current kernel (bd45ac0c5daa...)
    does NOT have the system hang and thus affecting all subsequent
    bisects. Worst case: this guess turns out to be false and I'm bisecting
    all through all ~2800 revisions without ever getting the correct "bad"
    one (because they were actually all "bad").

I tried 1), but did not get any further, as the next kernel did not boot 
either.
I tried 2), but did not get any further, as the next kernel did boot but 
locked up when I tried to use the device mapper.

Hope that's a bit better explained than before...

Thanks,
C.
-- 
BOFH excuse #58:

high pressure system failure
