Return-Path: <linux-kernel-owner+w=401wt.eu-S1762787AbZAHUDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787AbZAHUDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762640AbZAHUCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:02:53 -0500
Received: from lazybastard.de ([212.112.238.170]:58583 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbZAHUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:02:52 -0500
Date: Thu, 8 Jan 2009 21:02:43 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library V2
Message-ID: <20090108200243.GD24884@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org> <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org> <20081101155958.GA28776@logfs.org> <1231376241.3545.96.camel@johannes> <20090108162429.GA24884@logfs.org> <1231434601.8398.9.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231434601.8398.9.camel@johannes>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 January 2009 18:10:01 +0100, Johannes Berg wrote:
> On Thu, 2009-01-08 at 17:24 +0100, Jörn Engel wrote:
> 
> > If you want to open-code it, you can use btree_lookup_less().  I added
> > that function sometime last month.  Basically something like this:
> > 	key = btree_last(head, geo);
> > 	while (key) {
> > 		/* do something with key */
> > 		key = btree_lookup_less(head, geo, key);
> > 	}
> 
> Ok, so looking deeper into this, how about adding
> 
> #define btree_for_each_key(head, geo, key, tmp)	\
> 	for (key = btree_last(head, geo), tmp = btree_get_prev_key(head, geo, key);
> 	     key; key = tmp, tmp = btree_get_prev_key(head, geo, key))

[ Changed the function name above.  It really isn't a lookup, it returns
a key, not a value.  My fault. ]

Looks correct otherwise.  Probably needs a comment that without "tmp" we
would skip a 0 key.  Or am I the only one who wants to simplify the code
before spotting this little subtlety?

> (and possibly some type-checking variants that hardcode the geo)
> 
> Does that seem correct? And would it be possible to provide btree_last()
> that takes an void ** and fills it with the last entry, and the same for
> lookup_less(), so we can write btree_for_each_entry() too?

Not sure what you mean.  Something with the same effect as this?

#define btree_for_each_val(head, geo, key, val)				\
	 for (key = btree_last(head, geo),				\
	 		val = btree_lookup(head, geo, key);		\
	 		val;						\
			key = btree_get_prev_key(head, geo, key),	\
			val = btree_lookup(head, geo, key))

Jörn

-- 
Time? What's that? Time is only worth what you do with it.
-- Theo de Raadt
