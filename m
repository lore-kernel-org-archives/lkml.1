Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZAMWES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZAMWES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZAMWEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:04:05 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:56502 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZAMWEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:04:02 -0500
Date: Wed, 14 Jan 2009 01:04:01 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113220401.GE27227@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090113234952.451A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113234952.451A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Jan 14, 2009 at 01:35:36AM +0900, KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > +	/*
> > +	 * We did not find the process with requested string in its name,
> > +	 * so lets search for the usual victim.
> > +	 */
> > +	if (name && !chosen) {
> > +		name = NULL;
> > +		goto again;
> > +	}
> > +
> >  	return chosen;
> 
> this patch makes oom handling slower.
> slow bad process selection cause next another out of memory.
> 
> then, your trouble become large.
 
It really does not. As I described, when task does not have a valid
name, all checks are skipped.

So effectively it equals to the additional check in the loop, which
although being non-zero, but really is very small, since most of the
time process does not match and only single letter of the name should be
checked.

-- 
	Evgeniy Polyakov
