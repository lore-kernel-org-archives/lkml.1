Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbYAPSzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbYAPSzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYAPSzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:55:40 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3899 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYAPSzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:55:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YGVGAijTWOTjfnHgI+OSP0OZxYaehhLk7E8q9O+pweyrssBOMgpYy621C9tSCsMhH
	gxwPSP63qyvzYebnhqD4Q==
Message-ID: <532480950801161055u4191ef1ak644dd4528ab60f8@mail.gmail.com>
Date: Wed, 16 Jan 2008 10:55:28 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <400452490.28636@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080115080921.70E3810653@localhost>
	 <1200386774.15103.20.camel@twins>
	 <532480950801150953g5a25f041ge1ad4eeb1b9bc04b@mail.gmail.com>
	 <400452490.28636@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 7:01 PM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> Basically I think rbtree is an overkill to do time based ordering.
> Sorry, Michael. But s_dirty would be enough for that. Plus, s_more_io
> provides fair queuing between small/large files, and s_more_io_wait
> provides waiting mechanism for blocked inodes.

I think the flush_tree (which is a little more than just an rbtree)
provides the same queuing mechanisms that the three or four lists
heads do and manages to do it in one structure. The i_flushed_when
provides the ability to have blocked inodes wait their turn so to
speak.

Another motivation behind the rbtree patch is to unify the data
structure that handles the priority and mechanism of how we write out
the pages of the inodes. There are some ideas about introducing
priority schemes for QOS and such in the future. I am not saying this
patch is about making that happen, but the idea is to if possible
unify the four stages of lists into a single structure to facilitate
efforts like that.

mrubin
