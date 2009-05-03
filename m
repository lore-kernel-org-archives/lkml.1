Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZECV4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZECV4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZECV4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:56:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34404 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZECV4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:56:22 -0400
Date: Sun, 3 May 2009 23:56:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO 1/2] tomoyo: add Documentation/tomoyo.txt
Message-ID: <20090503215615.GA1368@ucw.cz>
References: <20090408133126.180521064@I-love.SAKURA.ne.jp> <20090408133524.395437925@I-love.SAKURA.ne.jp> <20090410171001.GA26156@elf.ucw.cz> <200904130204.n3D24JNk095583@www262.sakura.ne.jp> <20090501102438.GA7470@elf.ucw.cz> <200905012207.BFC60616.QStOHOMJFOLFFV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905012207.BFC60616.QStOHOMJFOLFFV@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-05-01 22:07:31, Tetsuo Handa wrote:
> Sorry for delayed response.
> 
> Pavel Machek wrote:
> > 2.5 Memory Allocation Rules
> > 
> > In TOMOYO Linux, memory allocated for holding access permissions and
> > words are never freed. There is no way except rebooting the system
> > that can free unneeded memory.
> > 
> > But don't worry. The policy seldom changes after you start production
> > mode. By tuning policy before starting production mode, you can reduce
> > memory usage to (usually) less than 1 MB.
> > 
> > ....does that mean that it leaks memory by design?
> 
> This is memory leak, but *controlled* memory allocation with a strategy for
> avoiding memory fragmentation and reducing memory usage. kstrdup()ing string
> data produces partially unused memory block since string data's length is
> unlikely power of two. Therefore, TOMOYO allocates memory in PAGE_SIZE bytes
> block and embeds string data as much as possible.
> TOMOYO does not continue allocating forever.

The document above says otherwise. 'There is no way except rebooting
the system that can free unneeded memory' certainly looks like memory
leak. Plus it sounds like if you change the policy, it will not free
the old one, either.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
