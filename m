Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZBPTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZBPTz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZBPTzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:55:18 -0500
Received: from c-67-161-46-51.hsd1.ca.comcast.net ([67.161.46.51]:51230 "EHLO
	freya.yggdrasil.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750783AbZBPTzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:55:17 -0500
Date: Mon, 16 Feb 2009 11:51:22 -0800
From: "Adam J. Richter" <adam@yggdrasil.com>
To: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc5 hanging at boot when CONFIG_LOCK_STAT=y
Message-ID: <20090216195122.GA10883@yggdrasil.com>
References: <20090216065053.GA23037@yggdrasil.com> <20090216122912.GA6302@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216122912.GA6302@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 01:29:12PM +0100, Ingo Molnar wrote:
> 
> * Adam J. Richter <adam@yggdrasil.com> wrote:
> 
> > Hello Peter and Ingo,
> > 
> > 	Under linux-2.6.29-rc5, and I believe all earlier 2.6.29-rc
> > releases, CONFIG_LOCK_STAT=y causes my system to hang at boot when
> > booting from lilo-22.8.  Linux-2.6.28 does not have this hang.
> > Disabling LOCK_STAT or booting from grub avoids the hang.  [...]
> 
> hm, so if booting from LILO you see a hang, while when booting with GRUB 
> it works fine?
> 
> Could it be LILO messing up the kernel image loading somehow? LOCK_STAT 
> might just be the thing that brings the kernel over a specific size.
> 
> 	Ingo

	Thank you for your prompt responses, Peter and Ingo.

	I have a little more information to add, which is consistent
with but not does not prove your theory that kernel size is
the trigger.

	What I said about the hangs occuring in all 2.6.29-rc versions
was incorrect.  I just retried 2.6.29-rc1, rc2 and rc3, all with
LOCK_STAT=y, and only rc3 hung.  Here is the information that "size"
returns about these kernels, along with rc5 compiled with LOCK_STAT=n
(although I am not sure exactly which ELF sections it classifies as
text, data and bss).

   text    data     bss     dec   version	    LOCK_STAT	behavior
3612151 1803760 4530176 9946087   linux-2.6.29-rc1  Y           boots
3612498 1802768 4530176 9945442   linux-2.6.29-rc2  Y           boots
3831641 1802920 4530176 10164737  linux-2.6.29-rc3  Y           hangs
3825876  485816 4255744 8567436   linux-2.6.29-rc5  N           boots

	 Your theory may be right, although I would think that my
experiments in splicing together .config files that did and did not
have this problem would have produced some smaller kernels that had
the problem, given that the configuration that did not hang was much
smaller.  However, I do not have those kernel images handy to test,
and I do not have time to do a lot of recompilations right now.
Perhaps late tonight I may try some more experiments.

	Thanks again for your responses.

Adam Richter
