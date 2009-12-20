Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZLTXud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZLTXud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 18:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZLTXub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 18:50:31 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:30278 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbZLTXu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 18:50:28 -0500
Subject: Re: [PATCH 0/12] pci: update pci bridge resources
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <4B2BEC0E.3050909@kernel.org>
References: <4B2BEC0E.3050909@kernel.org>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 16:44:32 -0700
Message-Id: <1261352672.26429.41.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 12:54 -0800, Yinghai Lu wrote:
> this patche set is trying to update pci bridge BAR when that BAR is big enough.
> 
> default it is disabled.
> 
> could use pci=try=2 to enable it.

Thanks for posting this as a nice new series.  It was getting hard to
figure out what went where.

I think you mean "when the BAR is *not* big enough."  And strictly
speaking, I think you're concerned with the bridge *window*, which isn't
actually a bridge BAR.

I don't like the new "pci=try=2" parameter.  Linux should be smart
enough to do the right thing without requiring the user to do something
special.  Using a parameter to enable the new code makes it feel like
"here's some new functionality, but I'm not sure it's safe enough for
everybody to use, so try this parameter if you need it."

The result is that the new code will be rarely used and poorly tested,
yet it remains a burden to all future PCI maintainers, who will have to
understand it and try not to break it.

Can you please put the "-v2"-type comments about your development
history in the [0/n] email?  They are useful while reviewing the
different versions, but they don't need to be in the commit logs.

Also, some of the patches in this series have "-v2" in subject, others
have "-v3", others have nothing.  It's easier to follow development of
the series if the version applies to the series as a whole, not to
individual patches.  The version doesn't need to be on the patch subject
line, because that will go into the commit log, where it won't be
relevant.  Tools like stgit put it where it will be automatically
discarded, e.g., "[PATCH -v2 x/n]"

Bjorn

