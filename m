Return-Path: <linux-kernel-owner+w=401wt.eu-S964811AbZJOXzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811AbZJOXzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763345AbZJOXzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:55:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55670 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbZJOXzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:55:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Oct 2009 08:52:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 6/9] swap_info: swap_map of chars not shorts
Message-Id: <20091016085208.6c6870cb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0910152308490.4447@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
	<Pine.LNX.4.64.0910150152330.3291@sister.anvils>
	<20091015114435.9470890a.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910152308490.4447@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 23:17:20 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> > On Thu, 15 Oct 2009 01:53:52 +0100 (BST)
> > Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > > @@ -1175,6 +1175,12 @@ static int try_to_unuse(unsigned int typ
> > >  		 * If that's wrong, then we should worry more about
> > >  		 * exit_mmap() and do_munmap() cases described above:
> > >  		 * we might be resetting SWAP_MAP_MAX too early here.
> > > +		 *
> > > +		 * Yes, that's wrong: though very unlikely, swap count 0x7ffe
> > > +		 * could surely occur if pid_max raised from PID_MAX_DEFAULT;
> > 
> > Just a nitpick.
> > 
> > Hmm, logically, our MAX COUNT is 0x7e after this patch. Then, how about not
> > mentioning to 0x7ffe and PID_MAX ? as..
> > 
> > Yes, that's wrong: we now use SWAP_MAP_MAX as 0x7e, very easy to overflow.
> > next patch will...
> 
> Perhaps we're reading it differently: I was there inserting a comment
> on what was already said above (with no wish to change that existing
> comment), then going on (immediately below) to mention how this patch
> is now lowering SWAP_MAP_MAX to 0x7e, making the situation even worse,
> but no worries because the next patch fixes it.
> 
yes.

> If you are seeing a nit there, I'm afraid it's one too small for my
> eye! 

I don't think it's very troublesome, but in these days, people seems to love
"bisect", Then, comments for change and comments for code should be divided, IMHO.

> And the lifetime of this comment, in Linus's git history, will
> be (I'm guessing) a fraction of a second - becoming a non-issue, it
> rightly gets deleted in the next patch.

ya, thanks.

Regards,
-Kame

