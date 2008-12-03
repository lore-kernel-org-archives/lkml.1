Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYLCTHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYLCTHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYLCTG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:06:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775AbYLCTG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:06:56 -0500
Date: Wed, 3 Dec 2008 11:06:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Mark Jackson" <mpfj@mimc.co.uk>, linux-kernel@vger.kernel.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: Badness at mm/backing-dev.c:179
Message-Id: <20081203110600.665af037.akpm@linux-foundation.org>
In-Reply-To: <ac3eb2510812030422n15f1be2cn77aa5f66f1046933@mail.gmail.com>
References: <49367691.5060007@mimc.co.uk>
	<ac3eb2510812030422n15f1be2cn77aa5f66f1046933@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 13:22:47 +0100 "Kay Sievers" <kay.sievers@vrfy.org> wrote:

> On Wed, Dec 3, 2008 at 13:07, Mark Jackson <mpfj@mimc.co.uk> wrote:
> > The following commit causes a "Badness at mm/backing-dev.c:179":-
> >
> > f1d0b063d993527754f062c589b73f125024d216 is first bad commit
> > commit f1d0b063d993527754f062c589b73f125024d216
> > Author: Kay Sievers <kay.sievers@vrfy.org>
> > Date:   Tue Dec 2 10:31:50 2008 -0800
> >
> >    bdi: register sysfs bdi device only once per queue
> 
> > Below is the extract from dmesg:-
> >
> > ------------[ cut here ]------------
> > Badness at mm/backing-dev.c:179
> 
> That's a known issue, and will not cause any harm besides printing
> this warning. Andrew added the warning to catch drivers who use one
> single request queue for multiple devices. Currently known are mtd and
> floppy (triggers only if you have more than one device per driver).
> The drivers need to be changed to use a separate queue per device, to
> get rid of this warning.

Actually, adding that warning wasn't such a great idea - we'll just get
heaps of email about things we already know about.  I think I'll take
it out again.

Which means this stuff won't get fixed for ages :(
