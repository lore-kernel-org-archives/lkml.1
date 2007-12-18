Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbXLRSOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbXLRSOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762168AbXLRSOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:14:46 -0500
Received: from waste.org ([66.93.16.53]:47106 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbXLRSOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:14:45 -0500
Date: Tue, 18 Dec 2007 12:13:43 -0600
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com, tytso@thunk.org
Subject: Re: Top kernel oopses/warnings this week
Message-ID: <20071218181343.GA19691@waste.org>
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org> <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com> <476703A4.7000401@linux.intel.com> <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com> <20071217154727.404e4bc4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org> <47680C16.1090905@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47680C16.1090905@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 10:06:14AM -0800, Arjan van de Ven wrote:
> Linus Torvalds wrote:
> >
> >On Mon, 17 Dec 2007, Arjan van de Ven wrote:
> >>+char *get_boot_uuid(void)
> >>+{
> >>+	static char target[38];
> >>+	unsigned char *uuid;
> >>+
> >>+	if (sysctl_bootid[8] == 0)
> >>+		generate_random_uuid(sysctl_bootid);
> >>+	/* sysctl_bootid is signed, to print we need unsigned .. */
> >>+	uuid = sysctl_bootid;
> >>+
> >>+	if (target[0] == 0) {
> >>+		sprintf(target, 
> >>"%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
> >>+			"%02x%02x%02x%02x%02x%02x",
> >
> >Why isn't *everything* inside that "if (target[0] == 0" check?
> >
> >IOW, that function should look something like
> 
> 
> ok so this got a lot more involved than I was hoping for;
> something like below will help me (and kerneloops.org ;) for the short term,
> while I'll see what I can do for random.c in a few dead moments soon, for a 
> 2.6.25
> enhancement...

Might as well leave out the null UUID, no sense in claiming to have
one when you don't. It's easy for a parser to cut on "^---["

-- 
Mathematics is the supreme nostalgia of our time.
