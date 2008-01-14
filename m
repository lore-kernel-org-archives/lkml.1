Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYAOA4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYAOA4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 19:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYAOA4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 19:56:10 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37055 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752778AbYAOA4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 19:56:08 -0500
Message-ID: <400358577.30629@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 14 Jan 2008 20:50:53 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <peterz@infradead.org>
Cc: jplatte@naasa.net, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <20080114035439.GA7330@mail.ustc.edu.cn> <400304530.01514@ustc.edu.cn> <200801141230.13694.jplatte@naasa.net> <1200310886.15103.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200310886.15103.1.camel@twins>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JEOmD-0001Ap-U7@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 12:41:26PM +0100, Peter Zijlstra wrote:
> 
> On Mon, 2008-01-14 at 12:30 +0100, Joerg Platte wrote:
> > Am Montag, 14. Januar 2008 schrieb Fengguang Wu:
> > 
> > > Joerg, this patch fixed the bug for me :-)
> > 
> > Fengguang, congratulations, I can confirm that your patch fixed the bug! With 
> > previous kernels the bug showed up after each reboot. Now, when booting the 
> > patched kernel everything is fine and there is no longer any suspicious 
> > iowait!
> > 
> > Do you have an idea why this problem appeared in 2.6.24? Did somebody change 
> > the ext2 code or is it related to the changes in the scheduler?
> 
> It was Fengguang who changed the inode writeback code, and I guess the
> new and improved code was less able do deal with these funny corner
> cases. But he has been very good in tracking them down and solving them,
> kudos to him for that work!

Thank you.

In particular the bug is triggered by the patch named:
        "writeback: introduce writeback_control.more_io to indicate more io"
That patch means to speed up writeback, but unfortunately its
aggressiveness has disclosed bugs in reiserfs, jfs and now ext2.

Linus, given the number of bugs it triggered, I'd recommend revert
this patch(git commit 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b). Let's
push it back to -mm tree for more testings?

Regards,
Fengguang

