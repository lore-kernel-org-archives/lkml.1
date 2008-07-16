Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbYGPO6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbYGPO6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYGPO6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:58:08 -0400
Received: from mylar.outflux.net ([69.93.193.226]:42379 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbYGPO6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:58:07 -0400
X-Greylist: delayed 2256 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2008 10:58:07 EDT
Date: Wed, 16 Jul 2008 07:20:22 -0700
From: Kees Cook <kees@outflux.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: useless kernel.maps_protect and more
Message-ID: <20080716142022.GU5794@outflux.net>
References: <20080716021135.GA5973@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716021135.GA5973@martell.zuzino.mipt.ru>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 16, 2008 at 06:11:35AM +0400, Alexey Dobriyan wrote:
> commit 5096add84b9e96e2e0a9c72675c442fe5433388a
> "proc: maps protection"
> 
> commit 831830b5a2b5d413407adf380ef62fe17d6fcbf2
> "restrict reading from /proc/<pid>/maps to those who share ->mm or can ptrace pid"
> 
> After Al added mm_for_maps(), maps_protect stopped controlling anything,
> because they're run at ->show time, but mm_for_maps() checks are done at
> ->start time.
> 
> Unless anyone objects, I'll remove maps_protect.

As long as this provides the same protections as maps_protect, I'm fine
with it.  I am a bit confused, though, since the reason I had to create
the sysctl entry in the first place was because akpm objected to the
maps file disappearing without a tunable.  Has this objection gone away?

> Also, logic behind second commit applies to /proc/*/pagemap , don't you
> think?

If that file shows memory location, yes.  What about the numa maps that
the first commit protects?

Thanks,

-Kees

-- 
Kees Cook                                            @outflux.net
