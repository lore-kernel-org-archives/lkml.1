Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYGFA3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYGFA3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 20:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbYGFA3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 20:29:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbYGFA3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 20:29:31 -0400
Date: Sat, 5 Jul 2008 17:28:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
cc: Andrey Borzenkov <arvidjaar@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: All 2.6.26-rcX hang immediately after loading ohci_hcd
In-Reply-To: <200807051704.56141.david-b@pacbell.net>
Message-ID: <alpine.LFD.1.10.0807051724090.3016@woody.linux-foundation.org>
References: <200807051108.20183.arvidjaar@mail.ru> <alpine.LFD.1.10.0807051317450.2815@woody.linux-foundation.org> <200807051704.56141.david-b@pacbell.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Jul 2008, David Brownell wrote:
> 
> I seem to recall some oddness with RHSC on some platforms,
> way back when I had lots of OHCI hardware and did comparative.
> testing.  RHSC and RD did not act quite like the docs said ...
> 
> Simple experiments:  add "distrust_firmware=y" to the ohci
> module options.  Or:  try a kernel without CONFIG_PM enabled.

I think Andrey said he was leaving for a week, so I don't think he'll be 
testing now.

But Andrey - if you are on-line and have access to the machine, one thing 
to try would be to just do a 

	git revert e872154921a6b5

in case it really was that particular commit. It seems to revert cleanly 
(although I didn't actually check if the result then compiled/worked).

And a "git bisect" would obviously be wonderful in case it wasn't.

			Linus
