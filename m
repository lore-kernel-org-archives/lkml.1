Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbYHHVow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbYHHVow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761634AbYHHVo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:44:27 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:18538 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761600AbYHHVo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:44:26 -0400
Date: Fri, 8 Aug 2008 23:45:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bastian Blank <bastian@waldi.eu.org>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] DocBook: don't compress mandocs
Message-ID: <20080808214504.GA8001@uranus.ravnborg.org>
References: <20080808074724.GA28249@wavehammer.waldi.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808074724.GA28249@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 09:47:24AM +0200, Bastian Blank wrote:
> The mandocs target uses gzip to compress the resulting manpages. If this
> target runs more than once (using make -jX) at the same time, gzip may
> run more then once with the same set of files. It just bails out if it
> is not able to find a file because a concurrent run already removed it.
> 
> Fix this by removing the gzip call and only work with uncompressed
> manpages.

If it failded with gzip being run more than once before this
patch does not solve the bug - it simply makes it harder to trigger.

Anything that does not work with a make -j100 build is broken.
And please understand that we have people that uses "make -j100" when building
the kernel.

These people most likely does not do "make mandocs" but we should still fix
the bug and not try to paper it over in this way.

So try to analyse why we in the first place will run gzip in parallele and solve that.

	Sam
