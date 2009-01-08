Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbZAHQYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbZAHQYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZAHQYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:24:39 -0500
Received: from lazybastard.de ([212.112.238.170]:55170 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbZAHQYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:24:38 -0500
Date: Thu, 8 Jan 2009 17:24:29 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library V2
Message-ID: <20090108162429.GA24884@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org> <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org> <20081101155958.GA28776@logfs.org> <1231376241.3545.96.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231376241.3545.96.camel@johannes>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 January 2009 01:57:21 +0100, Johannes Berg wrote:
> On Sat, 2008-11-01 at 16:59 +0100, Jörn Engel wrote:
> 
> [btree library]
> 
> Alright, back to this. I'm going to need something like the patch below
> (except the update facility, which I thought I needed but then changed
> my mind) which is on top of your patch. Does that look sane?

At first glance it does.  The update looks like someone might need it,
but doesn't have a user yet.  The btree_merge is similar, as I used to
need it, but no longer do.  Maybe #if 0 those two.

> One thing that seems a little odd is requiring a btree_init(), but not
> having a btree_destroy(), but rather requiring managing the mempool in
> the caller (which invariably leads to two mempool pointers being
> required unless callers want to look into the btree struct details)...
> Do you think this is required? Could we have a btree_init/btree_destroy
> instead that take care of the mempool stuff?

Well, I used to have heaps of btrees around and wanted to share the
mempool between all of them.  Not sure if I still do, I believe not.
Will check.

If mempools aren't shared, I agree that encapsulating those bits is much
nicer.

> Another thing that I need is a visitor that deletes _some_ entries. How
> can I do that? Additionally, it would be nice to be able to abort a tree
> walk, when you have determined that you can't continue for whatever
> reason.

If you want to open-code it, you can use btree_lookup_less().  I added
that function sometime last month.  Basically something like this:
	key = btree_last(head, geo);
	while (key) {
		/* do something with key */
		key = btree_lookup_less(head, geo, key);
	}

Maybe it should be renamed to btree_get_prev_key().  I never noticed how
confusing it was because my head was busy with other problems.  The code
is currently burried within my logfs tree:
http://logfs.org/git?p=logfs;a=summary

Will merge it with your patch and respin later tonight or tomorrow...

Jörn

-- 
I can say that I spend most of my time fixing bugs even if I have lots
of new features to implement in mind, but I give bugs more priority.
-- Andrea Arcangeli, 2000
