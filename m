Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbYJVIbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbYJVIbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYJVIbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:31:35 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:38875 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYJVIbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:31:34 -0400
Date: Wed, 22 Oct 2008 09:31:41 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: penguin-kernel@i-love.sakura.ne.jp
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: */ in string confuses checkpatch.pl
Message-ID: <20081022083141.GB22344@brain>
References: <200810210057.m9L0vQ7i012829@www262.sakura.ne.jp> <20081022075617.GA22344@brain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022075617.GA22344@brain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 08:56:17AM +0100, Andy Whitcroft wrote:
> On Tue, Oct 21, 2008 at 09:57:26AM +0900, penguin-kernel@i-love.sakura.ne.jp wrote:
> > Hello.
> > 
> > The below code confuses checkpatch.pl ver 0.21.
> > 
> > Regards.
> > ----------
> > # cat /tmp/foo.c
> > void foo(void)
> > {
> > 	bar(\" /proc/\\\\*/\");
> > 	bar(\" /proc/\\\\$/\");
> > }
> > # /usr/src/vanilla/linux-2.6.27.2/scripts/checkpatch.pl --file /tmp/foo.c
> > ERROR: need consistent spacing around \'/\' (ctx:WxV)
> > #4: FILE: tmp/foo.c:4:
> > +       bar(\" /proc/\\\\$/\");
> >               ^
> > 
> > total: 1 errors, 0 warnings, 5 lines checked
> > 
> > /tmp/foo.c has style problems, please review.  If any of these errors
> > are false positives report them to the maintainer, see
> > CHECKPATCH in MAINTAINERS.

Ok, I can see whats happened here.  Most of these \'s are extraneous.
Without those I can reproduce this.  Its a bug in the 'comment is open
at the start of hunk' detection.  I think I have updated this heuristic
to cope wit this.  Could you try your original patch (I assume there was
one) with the version below:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

Thanks for your report.

-apw
