Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbYAKQQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbYAKQQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759651AbYAKQPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:15:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759416AbYAKQPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:15:52 -0500
Date: Fri, 11 Jan 2008 11:15:37 -0500
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080111111537.6bd2f5e4@bree.surriel.com>
In-Reply-To: <1200067158.5304.17.camel@localhost>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
	<20080111143627.FD64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080111104258.2d1df3de@bree.surriel.com>
	<1200067158.5304.17.camel@localhost>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 10:59:18 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Fri, 2008-01-11 at 10:42 -0500, Rik van Riel wrote:
> > On Fri, 11 Jan 2008 15:24:34 +0900
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > below patch is a bit cleanup proposal.
> > > i think LRU_FILE is more clarify than "/2".
> > > 
> > > What do you think it?
> > 
> > Thank you for the cleanup, your version looks a lot nicer.  
> > I have applied your patch to my series.
> > 
> 
> Rik:  
> 
> I think we also want to do something like:
> 
> -	BUILD_BUG_ON(LRU_INACTIVE_FILE != 2 || LRU_ACTIVE_FILE != 3);
> +	BUILD_BUG_ON(LRU_INACTIVE_FILE != 2 || LRU_ACTIVE_FILE != 3 ||
> +		NR_LRU_LISTS > 6);
> 
> Then we'll be warned if future change might break our implicit
> assumption that any lru_list value with '0x2' set is a file lru.

Restoring the code to your original version makes things work again.

OTOH, I almost wonder if we should not simply define it to

	return (l == LRU_INACTIVE_FILE || l == LRU_ACTIVE_FILE)

and just deal with it.

Your version of the code is correct and probably faster, but not as
easy to read and probably not in a hot path :)

-- 
All rights reversed.
