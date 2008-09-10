Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYIJRkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYIJRkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYIJRkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:40:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbYIJRkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:40:11 -0400
Date: Wed, 10 Sep 2008 13:39:41 -0400
From: Rik van Riel <riel@redhat.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: hamid.jahanjou@gmail.com, "Zan Lynx" <zlynx@acm.org>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
Message-ID: <20080910133941.61ceb087@bree.surriel.com>
In-Reply-To: <2c0942db0809101008j55ea39dfx8dbf6284d4de749@mail.gmail.com>
References: <48BFCECE.90103@gmail.com>
	<87iqtbuez9.fsf@basil.nowhere.org>
	<48C19648.8030002@gmail.com>
	<20080905194501.GZ18288@one.firstfloor.org>
	<20080906014214.22f28548@riellaptop.surriel.com>
	<48C471AE.8060809@acm.org>
	<20080907205536.0d1937ff@riellaptop.surriel.com>
	<48C78246.7050507@gmail.com>
	<2c0942db0809101008j55ea39dfx8dbf6284d4de749@mail.gmail.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 10:08:07 -0700
"Ray Lee" <ray-lk@madrabbit.org> wrote:
> On Wed, Sep 10, 2008 at 1:16 AM, Hamid R. Jahanjou
> <hamid.jahanjou@gmail.com> wrote:
> > I agree. As you said, we have two conflicting requirements here: on the
> > one hand one likes to swap as many pages as to satisfy the backing
> > storage "proper block IO size," on the other hand, one should not make a
> > process lose too many pages.
> 
> I'd much rather that one process lose a lot of pages than many
> processes lose a few. When a system is swap thrashing, each process
> has some of its active working set tossed to swap, which means *any*
> application you try to switch to is then sluggish. If it were only one
> application, then only that one takes the penalty hit when the user
> switches focus and context.

Better still, with proper IO clustering that one process can get
its pages back into memory quite quickly.

Paging of anonymous pages is limited by disk seeks, so minimizing
those is a top goal.

-- 
All rights reversed.
