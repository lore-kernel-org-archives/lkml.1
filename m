Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbYEYQ1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbYEYQ1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 12:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYEYQ1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 12:27:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYEYQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 12:27:09 -0400
Date: Sun, 25 May 2008 18:35:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Glauber Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       andi-suse@firstfloor.org
Subject: Re: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
Message-ID: <20080525163539.GA8405@one.firstfloor.org>
References: <20080521113028.GA24632@xs4all.net> <48341A57.1030505@redhat.com> <20080522084736.GC31727@one.firstfloor.org> <1211484343.30678.15.camel@localhost.localdomain> <1211657898.25661.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211657898.25661.2.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So how about linux-2.6.26-gfp-no-oom.patch (see previous mail) for
> 2.6.26 

Changing the gfp once globally like you did is not right, because
the different fallback cases have to be handled differently
(see the different cases I discussed in my earlier mail)

Especially the 16MB zone allocation should never trigger the OOM killer.

That could be special cased, but __GFP_NO_OOM_KILLER is likely better
as a short term fix although I'm still not 100% sure what implications
it will have to do more VM replies in the early fallbacks.

-Andi
