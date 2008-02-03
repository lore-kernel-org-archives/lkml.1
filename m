Return-Path: <linux-kernel-owner+w=401wt.eu-S936147AbYBCJAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936147AbYBCJAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 04:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758551AbYBCJAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 04:00:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41669 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757043AbYBCJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 04:00:24 -0500
Date: Sun, 3 Feb 2008 01:00:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] Split list.h and move rcu-protected lists into
 rculist.h
Message-Id: <20080203010013.04bc601e.akpm@linux-foundation.org>
In-Reply-To: <47A57F25.5070902@gmail.com>
References: <478FBEA0.9090203@gmail.com>
	<478FBEEA.6040000@gmail.com>
	<20080201155826.a2d308c1.akpm@linux-foundation.org>
	<47A470F9.9060708@gmail.com>
	<20080202111516.5cbd0880.akpm@linux-foundation.org>
	<47A57F25.5070902@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Feb 2008 09:45:25 +0100 Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:

> Andrew Morton wrote:
> > On Sat, 02 Feb 2008 14:32:41 +0100 Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:
> >> Do you think it's better ?
> > 
> > Could.  I'd suggest that you redo the header-file split patch around the
> > 2.6.25-rc1 timeframe, test it carefully then let's get it in then.
> > 
> 
> Does the mm tree also have a calm down period during release candidates ?

Yes, I try to not merge too much material late in the -rcs and in the merge
window.  Often it's not practical to merge things anyway, because people
prepare patches against mainline, which is ancient history...

> I have modified the patchset so now if rcu helpers are used from
> rculist.h then fine otherwise gcc warns you that you're using the
> helpers from list.h like this:
> 
> init/foo.c:13: warning: ‘__deprecated_list_add_rcu’ is deprecated (declared at include/linux/rculist.h:76)
> 
> But the build process doesn't fail anymore.
> 
> For that I added some ugly hacks in list.h and rculist.h but they
> definitively should be removed for mainline inclusion. I'm sending them
> in response to this email.

I wouldn't bother, really.  Let's just get it as good as we can and slam it
in.

> If we include this now, then people can have a chance to notice that
> rculist.h exists and fix their stuffs until 2.6.25 release
> candidates but I'll redo the patchset and give it some test around the
> 2.6.25-rc1 timeframe anyway.

I'm just about finished compilation-testing for 2.6.24-mm1 which is a
shame.  Please do a best-effort against 2.6.24-mm1 (hopefully I'll get that
out tomorrow) and I'll slip it into -rc1 if it gets through cross-build
testing without unfixable-with-my-patience-level problems.



