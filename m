Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbZEMAh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbZEMAh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759378AbZEMAhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:37:32 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42530 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759350AbZEMAha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:37:30 -0400
Date: Tue, 12 May 2009 20:37:27 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Message-ID: <20090513003727.GA12788@localhost.localdomain>
References: <200905111006.32675.jarod@redhat.com> <200905121602.45960.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905121602.45960.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 04:02:45PM -0400, Jarod Wilson wrote:
> On Monday 11 May 2009 10:06:32 Jarod Wilson wrote:
> > At present, the tcrypt module always exits with an -EAGAIN upon
> > successfully completing all the tests its been asked to run. There
> > are cases where it would be much simpler to verify all tests passed
> > if tcrypt simply stayed loaded (i.e. returned 0). Specifically, in
> > fips mode, all self-tests need to be run from the initrd, and its
> > much simpler to check the ret from modprobe for success than to
> > scrape dmesg. To make this doable, I've simply added a module param
> > to allow this behavior, leaving the default behavior more or less
> > the same as before, although now we're tracking all success/failure
> > rets as well.
> 
> I've been reminded that a self-test failure in fips mode means an
> immediate panic, so modprobe never sees the ret in that case, but if
> the module load failed for other reasons, a non-zero return value
> from modprobe is possible w/o traversing the code paths that trigger
> a self-test failure panic. For one, if the tcrypt module were to go
> missing for some reason, modprobe would have a non-zero ret, and the
> initrd would need to handle panicking the system.
> 
> Would there be any objections to dropping the noexit parameter
> entirely and just making its behavior the default? It would make
> all users regardless of fips mode notice failures more readily.
> 
I think thats a fine idea.  Theres no reason that a user of the tcrypt module
can't manually rmmod it when the testing is done.  Doing it that way just seems
more sane to me to begin with anyway.

Neil

> -- 
> Jarod Wilson
> jarod@redhat.com
> 
