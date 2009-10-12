Return-Path: <linux-kernel-owner+w=401wt.eu-S933418AbZJLWF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418AbZJLWF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbZJLWFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:05:25 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:58980 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933284AbZJLWFY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:05:24 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Date: Tue, 13 Oct 2009 00:04:44 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu>
In-Reply-To: <20091012195733.GA7351@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910130004.46388.elendil@planet.nl>
X-OriginalArrivalTime: 12 Oct 2009 22:04:46.0599 (UTC) FILETIME=[02ACB970:01CA4B88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Ingo Molnar wrote:
> It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial
> way:
>
>  - if it is set, things work the way they always have, and you get a
>    extended kernel release like:
>
>         2.6.32-rc3-00052-g0eca52a
>
>  - but if it is _not_ set, we'll still try to get a version from the
>    underlying SCM (we actually support git, hg and SVN right now, even
> if some comments may say "git only"), and if the underlying SCM says it
> has a local version, we append just "+", so you get a version number
> like:
>
>         2.6.32-rc3+

I don't object to making this the default (even a strong default), but I 
still don't like the fact that it's not optional.
IMO both LOCALVERSION_AUTO *and* the added "+" can be unsuitable for some 
use cases, for example for distributions.

If someone uses git to manage their custom patches, the only out this patch 
leaves them to avoid the "+" is to revert it in their own trees. IMO that 
should not be necessary.

To repeat some comments from <200910062137.06593.elendil@planet.nl>:
<snip>
Linus wrote:
> That said, we might make it a lot harder for people to overlook this by
> mistake when they don't care or know enough. Maybe we can have three
> levels of the "automatic" version number, and make the third level ("no
> automatic sign of versioning at all") be something that you really need
> to ask for (eg you need to have EMBEDDED enabled to show that you want
> the whole extended config option setup or something fairly draconian
> like that).

I'd opt for the "or something" as I think it would be a mistake to link it 
to EMBEDDED. That has a rather different purpose.

One case to consider is distributions. They will have their own patches, 
possibly as a branch off mainline in git.
AFAICT with the current patch they'd automatically always get the "+", 
which is almost certain to conflict with their own naming schemes.
Distro configs with EMBEDDED set also does not seem right. Nor should it 
IMHO be needed to have to patch the Makefile to get rid of it.

I think just having a config option with the three choices you suggest and 
an appropriate help text to guide users should be sufficient, with the one 
that activates the "+" as default.
</snip>

Cheers,
FJP
