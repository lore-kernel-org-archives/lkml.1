Return-Path: <linux-kernel-owner+w=401wt.eu-S1751078AbZJPEJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078AbZJPEJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 00:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZJPEJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 00:09:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37455 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZJPEJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 00:09:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Oct 2009 13:06:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
       hongshin@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/9] swap_info: swap count continuations
Message-Id: <20091016130622.8c096641.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0910160314310.2993@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
	<Pine.LNX.4.64.0910150153560.3291@sister.anvils>
	<20091015123024.21ca3ef7.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910160016160.11643@sister.anvils>
	<20091016102951.a4f66a19.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910160314310.2993@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009 03:24:57 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Fri, 16 Oct 2009, KAMEZAWA Hiroyuki wrote:
> > > 
> > My concern is that small numbers of swap_map[] which has too much refcnt
> > can consume too much pages.
> > 
> > If an entry is shared by 65535, 65535/128 = 512 page will be used.
> > (I'm sorry if I don't undestand implementation correctly.)
> 
> Ah, you're thinking it's additive: perhaps because I use the name
> "continuation", which may give that impression - maybe there's a
> better name I can give it.
> 
> No, it's multiplicative - just like 999 is almost a thousand, not 27.
> 
> If an entry is shared by 65535, then it needs its original swap_map
> page (0 to 0x3e) and a continuation page (0 to 0x7f) and another
> continuation page (0 to 0x7f): if I've got my arithmetic right,
> those three pages can hold a shared count up to 1032191, for
> every one of that group of PAGE_SIZE neighbouring pages.
> 
Ah, okay. I see. thank you for explanation.

Regards,
-Kame

