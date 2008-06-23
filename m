Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYFWHXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYFWHXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYFWHWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:22:53 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:56140 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097AbYFWHWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:22:50 -0400
Date: Mon, 23 Jun 2008 09:32:27 +0200
From: Andreas Herrmann <aherrman@arcor.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Hansjoerg Lipp <hjlipp@web.de>, gigaset307x-common@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kkeil@suse.de
Subject: Re: [PATCH] gigaset: fix module reference counting
Message-ID: <20080623073227.GA6033@obelix>
References: <20080606223918.GA10348@kodscha> <4855A145.90803@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4855A145.90803@imap.cc>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 01:09:57AM +0200, Tilman Schmidt wrote:
> On 2008-06-07 00:39, Andreas Herrmann wrote:
> > bas_gigaset can't be unloaded due to wrong module reference counting.
> > Ensure that module_put is called whenever a channel is freed.
> 
> I'm not quite happy with that patch. Specifically, I see a risk of
> module_put being called too often.

> Could you explain in some more detail what bug you are trying to fix?
> Do you have a sequence of events which leads to a situation where the
> bas_gigaset module cannot be unloaded but should be?

I've tried to reproduce the problem doing various tests -- but without
success.

Then i've checked the code and there was already this fix:

commit e468c04894f36045cf93d1384183a461014b6840 (Gigaset: permit module unload)

This was commited after 2.6.24 was released.

And (shit happens!) on the machine where I've previously tested the
stuff I had also an 2.6.24 kernel installed.

So it seems that I have mixed up different kernel versions when I've
tested my patch. Because with current git-tree bas_gigaset can be
unloaded without any problems.

Sorry for the noise.


Regards,

Andreas

