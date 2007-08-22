Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbXHVC5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbXHVC5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 22:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXHVC5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 22:57:03 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58674 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbXHVC5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 22:57:01 -0400
X-Sasl-enc: XO5WPvmlv0Ot9f7KYHEFXijwjz+f7rPiIrhq88TGTLr7 1187751420
Subject: Re: [PATCH] autofs4: reinstate negatitive timeout of mount fails
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>
In-Reply-To: <20070821131551.4026fb96.akpm@linux-foundation.org>
References: <1187688369.3318.12.camel@raven.themaw.net>
	 <20070821131551.4026fb96.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 10:56:55 +0800
Message-Id: <1187751415.3899.9.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 13:15 -0700, Andrew Morton wrote:
> On Tue, 21 Aug 2007 17:26:09 +0800
> Ian Kent <raven@themaw.net> wrote:
> 
> > Due to a change to fs/dcache.c:d_lookup() in the 2.6 kernel whereby only
> > hashed dentrys are returned the negative caching of mount failures
> > stopped working in the autofs4 module for nobrowse mount (ie. directory
> > created at mount time and removed at umount or following a mount
> > failure).
> > 
> > This patch keeps track of the dentrys from mount fails in order to be
> > able check the timeout since the last fail and return the appropriate
> > status. In addition the timeout value is settable at load time as a
> > module option and via sysfs using the module
> > parameter /sys/module/autofs4/parameters/negative_timeout.
> 
> Boy, that's a complex-looking patch.  I think I'll sit on this one
> for 2.6.24 ;)

Yes, that's fine .. the principle isn't that complex.

> 
> It seems to use a lot of list_for_each[_safe] which could
> have been coded as list_for_each_entry[_safe], btw.

Mmm .. good point. I've not noticed the list_for_each_entry* macros.

Ian


