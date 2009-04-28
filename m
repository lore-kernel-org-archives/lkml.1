Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbZD1HtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbZD1HtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZD1Hs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:48:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZD1Hsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:48:55 -0400
Subject: Re: Swappiness vs. mmap() and interactive response
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090428143019.EBBF.A69D9226@jp.fujitsu.com>
References: <20090428044426.GA5035@eskimo.com>
	 <20090428143019.EBBF.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Apr 2009 09:48:39 +0200
Message-Id: <1240904919.7620.73.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 14:35 +0900, KOSAKI Motohiro wrote:
> (cc to linux-mm and Rik)
> 
> 
> > Hi,
> > 
> > So, I just set up Ubuntu Jaunty (using Linux 2.6.28) on a quad core phenom box,
> > and then I did the following (with XFS over LVM):
> > 
> > mv /500gig/of/data/on/disk/one /disk/two
> > 
> > This quickly caused the system to. grind.. to... a.... complete..... halt.
> > Basically every UI operation, including the mouse in Xorg, started experiencing
> > multiple second lag and delays.  This made the system essentially unusable --
> > for example, just flipping to the window where the "mv" command was running
> > took 10 seconds on more than one occasion.  Basically a "click and get coffee"
> > interface.
> 
> I have some question and request.
> 
> 1. please post your /proc/meminfo
> 2. Do above copy make tons swap-out? IOW your disk read much faster than write?
> 3. cache limitation of memcgroup solve this problem?
> 4. Which disk have your /bin and /usr/bin?
> 

FWIW I fundamentally object to 3 as being a solution.

I still think the idea of read-ahead driven drop-behind is a good one,
alas last time we brought that up people thought differently.
