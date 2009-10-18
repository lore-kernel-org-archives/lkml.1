Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZJRRWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZJRRWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 13:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZJRRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 13:22:42 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46482 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbZJRRWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 13:22:42 -0400
Date: Sun, 18 Oct 2009 13:22:33 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Sam Ravnborg <sam@ravnborg.org>
cc: Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] m68knommu: Move __init_end out of the .init
 section.
In-Reply-To: <20091014151616.GA6901@merkur.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu>
References: <4AD3BFD8.90408@snapgear.com> <1255397413-4862-1-git-send-email-tabbott@ksplice.com> <1255397413-4862-2-git-send-email-tabbott@ksplice.com> <1255397413-4862-3-git-send-email-tabbott@ksplice.com> <1255397413-4862-4-git-send-email-tabbott@ksplice.com>
 <1255397413-4862-5-git-send-email-tabbott@ksplice.com> <1255397413-4862-6-git-send-email-tabbott@ksplice.com> <1255397413-4862-7-git-send-email-tabbott@ksplice.com> <4AD55682.7060502@snapgear.com> <20091014151616.GA6901@merkur.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Sam Ravnborg wrote:

> Took a look at this trying to understand why this
> caused a non-booting system.

Thanks, I really appreciate your looking at this!

[...]
> I think the better solution is to use the same section name
> several times like this:
> 
> 	.init : {
>               . = ALIGN(PAGE_SIZE);
>               __init_end = .;
>       } > INIT
> 
> We should do this both for begin and end.
> Then the linker will not fool us and try to rearrange stuff.
> And we do not end up with zero sized sections.

OK, I have an attempt at implementing this idea.  Of course, the final 
patch which uses INIT_TEXT_SECTION and INIT_DATA_SECTION has multiple 
output sections (.init.data and .init.text), but I think perhaps including 
these alignment guards in the adjacent section might work.

	-Tim Abbott

