Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbXFWRfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbXFWRfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbXFWRfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:35:32 -0400
Received: from server145.whmcpanel.net ([69.72.254.178]:52302 "EHLO
	server459.whmcpanel.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbXFWRfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:35:31 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Question about fair schedulers
Date: Sat, 23 Jun 2007 19:28:22 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706230007.15622.info@gnebu.es> <200706230946.44023.info@gnebu.es> <EC86BD0E-7829-4DBF-864A-795804235C5C@mac.com>
In-Reply-To: <EC86BD0E-7829-4DBF-864A-795804235C5C@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706231928.22862.info@gnebu.es>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server459.whmcpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Saturday 23 June 2007 18:35:18 Kyle Moffett escribió:
> If you want the kernel to
> treat one job or the other as more important then you must *TELL* it
> that, end of story.

Yes, that makes sense now that it's been explained to me conveniently. As long 
as a normal user is not left alone with such task (as it won't happen), I'm 
more than happy with the solution.

> > Yes, I see your point. In a scenario of dropping frames it seems
> > that CFS does a better job. It's just that an ideal scheduler
> > shouldn't drop frames in this case (it should give 70% to the video
> > even without nicing the encoder).
>
> It can't do that.  The with-CFS kernel just sees 2 CPU-heavy
> processes and guesses that it should give them equal CPU.  "stock"
> kernels have an algorithm designed to promote some tasks for
> "interactivity", but in practice it also tended to cause other
> processes to be denied CPU for arbitrarily long periods of time,
> hence why CFS is an improvement.  Under the old scheduler even if you
> had 2 DVD player processes each chewing 45% CPU, you could still have
> dropped frames because for a second or two one would be more
> "interactive" than the other, and vice versa.  Under CFS/SD, they are
> both classified equally and so get equal CPU allocation *AND* latency.

This adds even more sense to all the explanations I've heard up to now. 
Thanks :)

> I don't see any reason someone couldn't write a simple little GUI
> program to enumerate the user-owned X processes (somewhat like the
> Windows Task-Manager but less complicated) and allow them to change
> priorities.  Alternatively your desktop environment could set up a
> little privileged wrapper which appropriately executes the HD video
> player.  One of the primary rules of kernel development is that you
> cannot put policy in the kernel, and a statement of the form
> "PROCESS1 is more important than PROCESS2" is pure policy and must be
> done from userspace.  We even give appropriate enforcement mechanisms
> to userspace to take such action (nice levels).

Yes, an app to change priorities would be very nice, though I'd be happy with 
just sensible defaults. Probably once CFS or SD go mainline more application 
developers will make their apps run at the appropriate nice level (or else 
distributions will provide this when packaging the apps), so end users won't 
have any problems.

> Cheers,
> Kyle Moffett

Thank you,
Alberto.

