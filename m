Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbZJOWR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbZJOWR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758713AbZJOWR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:17:58 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:4867 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753790AbZJOWR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:17:58 -0400
X-Trace: 275022252/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.3.134/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.3.134
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAHc810pPRQOG/2dsb2JhbACBUtdFhDAE
X-IronPort-AV: E=Sophos;i="4.44,568,1249254000"; 
   d="scan'208";a="275022252"
Date: Thu, 15 Oct 2009 23:17:20 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 6/9] swap_info: swap_map of chars not shorts
In-Reply-To: <20091015114435.9470890a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0910152308490.4447@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
 <Pine.LNX.4.64.0910150152330.3291@sister.anvils>
 <20091015114435.9470890a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> On Thu, 15 Oct 2009 01:53:52 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > @@ -1175,6 +1175,12 @@ static int try_to_unuse(unsigned int typ
> >  		 * If that's wrong, then we should worry more about
> >  		 * exit_mmap() and do_munmap() cases described above:
> >  		 * we might be resetting SWAP_MAP_MAX too early here.
> > +		 *
> > +		 * Yes, that's wrong: though very unlikely, swap count 0x7ffe
> > +		 * could surely occur if pid_max raised from PID_MAX_DEFAULT;
> 
> Just a nitpick.
> 
> Hmm, logically, our MAX COUNT is 0x7e after this patch. Then, how about not
> mentioning to 0x7ffe and PID_MAX ? as..
> 
> Yes, that's wrong: we now use SWAP_MAP_MAX as 0x7e, very easy to overflow.
> next patch will...

Perhaps we're reading it differently: I was there inserting a comment
on what was already said above (with no wish to change that existing
comment), then going on (immediately below) to mention how this patch
is now lowering SWAP_MAP_MAX to 0x7e, making the situation even worse,
but no worries because the next patch fixes it.

If you are seeing a nit there, I'm afraid it's one too small for my
eye!  And the lifetime of this comment, in Linus's git history, will
be (I'm guessing) a fraction of a second - becoming a non-issue, it
rightly gets deleted in the next patch.

Hugh

> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> > +		 * and we are now lowering SWAP_MAP_MAX to 0x7e, making it
> > +		 * much easier to reach.  But the next patch will fix that.
