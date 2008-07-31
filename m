Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbYGaAMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbYGaAMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762555AbYGaALn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:11:43 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56613 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761682AbYGaALm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:11:42 -0400
Date: Thu, 31 Jul 2008 01:11:31 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
Message-ID: <20080731001131.GA30900@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And by papering it over, it then just makes people less likely to bother 
> > with the real issue.
> 
> I think you are talking about a totally separate issue: that NFSD's
> use of splice can result in strange things if the file is truncated
> while being read.  But this is an NFSD issue and I don't see that it
> has _anything_ to do with the above bug in splice.  I think you are
> just confusing the two things.

I'm more concerned by sendfile() users like Apache, Samba, FTPd.  In
an earlier thread on this topic, I asked if the splice bug can also
result in sendfile() sending blocks of zeros, when a file is truncated
after it has been sent, and the answer was yes probably.

Not that I checked or anything.  But if it affects sendfile() it's a
bigger deal - that has many users.

Assuming it does affect sendfile(), it's exasperated by not being able
to tell when a sendfile() has finished with the pages its sending.
E.g. you can't lock the file or otherwise synchronise with another
program which wants to modify the file.

-- Jamie
