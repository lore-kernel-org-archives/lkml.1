Return-Path: <linux-kernel-owner+w=401wt.eu-S964808AbZJOXux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808AbZJOXux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758360AbZJOXuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:50:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37576 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571AbZJOXuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:50:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Oct 2009 08:47:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] swap_info: change to array of pointers
Message-Id: <20091016084748.762330b6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0910152356110.9759@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
	<Pine.LNX.4.64.0910150146210.3291@sister.anvils>
	<20091015111107.b505b676.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910152324220.4447@sister.anvils>
	<Pine.LNX.4.64.0910152356110.9759@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009 00:04:14 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Thu, 15 Oct 2009, Hugh Dickins wrote:
> > On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> > > On Thu, 15 Oct 2009 01:48:01 +0100 (BST)
> > > Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > > > @@ -1675,11 +1674,13 @@ static void *swap_start(struct seq_file
> > > >  	if (!l)
> > > >  		return SEQ_START_TOKEN;
> > > >  
> > > > -	for (i = 0; i < nr_swapfiles; i++, ptr++) {
> > > > -		if (!(ptr->flags & SWP_USED) || !ptr->swap_map)
> > > > +	for (type = 0; type < nr_swapfiles; type++) {
> > > > +		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
> > > > +		si = swap_info[type];
> > > 
> > > 		if (!si) ?
> 
> Re-reading, I see that I missed your interjection there.
> 
> Precisely because we read swap_info[type] after reading nr_swapfiles,
> with smp_rmb() here to enforce that, and smp_wmb() where they're set
> in swapon, there is no way for si to be seen as NULL here.  Is there?
> 
Ah, sorry this is my mistake. I don't understand "nr_swapfiles never decreases
and swap_info[] will be never invalidated."

> Or are you asking for a further comment here on why that's so?
No.

> I think I'd rather just switch to taking swap_lock in swap_start()
> and swap_next(), than be adding comments on why we don't need it.
> 

Hmm, maybe.

Thanks,
-Kame

> Hugh
> 

