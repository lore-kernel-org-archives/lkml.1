Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYJaByT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYJaByT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYJaByJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:54:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYJaByI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:54:08 -0400
Date: Thu, 30 Oct 2008 21:54:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: Tim Gardner <tim.gardner@canonical.com>, Tomas Winkler <tomasw@gmail.com>,
       reinette chatre <reinette.chatre@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [MEMO] ftrace suckage++
In-Reply-To: <43e72e890810301445r665a0139g752fb1c97069fe59@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810302149330.21031@gandalf.stny.rr.com>
References: <43e72e890810301445r665a0139g752fb1c97069fe59@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Luis R. Rodriguez wrote:

> As johannes pointed out to me the culprit to the e1000e corruption was
> determined to be ftrace related [1]. Well it seems I hit an oops with
> ftrace using iwlagn after a simple load of the module using
> wireless-testing. I'm not sure if john's tree yet has ftrace fixes.
> Both Fedora 10 and Ubuntu 8.10 had dynamic ftrace enabled so users on
> these first kernels and using compat-wireless may run into this so
> just putting this out there. I'll can check for this flag in
> compat-wireless for now and bitch/exit if its enabled unless someone
> has a better idea.
> 
> [1] http://lwn.net/Articles/303390/
> 
> Oops, using wireless-testing and iwlagn with these options enabled:
> 
> CONFIG_HAVE_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_FTRACE=y
> CONFIG_DYNAMIC_FTRACE=y
> 

Yes, ftrace in 2.6.27 is known to be broken. That's why 2.6.27.1 labeled 
it as such. What is currently in Linus's 2.6.28 git tree is a completely 
rewritten version of the dynamic ftracer, which addresses all of the 
issues that caused breakage in the 2.6.27 release.

Do not use the 2.6.27 dynamic ftracer, it is known bad. 2.6.28 is fine. If 
you find issues with what is currently in 2.6.28, please let me know. 
There is currently some, "make allyesconfig" breakage that ftrace caused 
on archs other than x86,ppc and sparc, but patches to fix them are 
in queue to Linus.

-- Steve

