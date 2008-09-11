Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYIKOun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYIKOun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYIKOuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:50:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYIKOue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:50:34 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: davem@davemloft.net, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <200809111152.58187.elendil@planet.nl>
References: <48C68507.6000609@suse.com>
	 <1221088512.13621.58.camel@macbook.infradead.org>
	 <200809111043.34847.elendil@planet.nl>
	 <200809111152.58187.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 07:50:27 -0700
Message-Id: <1221144627.8593.9.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 11:52 +0200, Frans Pop wrote:
> Solution 2:
(separate firmware package)

This is what we're doing in Fedora, and what I think makes most sense.

At the moment, Fedora's package is still taken from the kernel source --
but fairly shortly, we'll move to building it from the linux-firmware
repository on kernel.org. That repository contains everything that's in
the kernel tree, and more -- now that we have it completely separate,
more companies are willing to allow us to include their firmware. We've
already rounded up some which were previously separate, and we'll
shortly be adding more firmware files which weren't previously available
to Linux users at all, except by copying it from the Windows installer.


> a) naturally allows firmware to be split between "free" and "non-free"

Indeed. So it allows the 'free software or nothing' nutters to have
their own replacement firmware package with none of the nasty stuff they
don't like.

> b) places a burden on the end-user to install/upgrade the firmware he
>    needs separately from the kernel

Not really. The new kernel package can just require the firmware
package. There's not really much of a burden on the end-user, is there?

> c) makes system installation more complex as the right additional firmware
>    package(s) need to be retrieved and installed

It's a simple dependency, handled just like dependencies normally are --
it's not exactly a giant leap in complexity.

> d) will break installed systems on upgrades (unless special measures are
>    taken): users may need to install additional firmware packages on a
>    kernel upgrade to keep a driver working

I have yet to see reports of it breaking Fedora. You upgrade the kernel,
the firmware package is automatically installed to satisfy the
dependency. And it just works.

Really, people seem to be imagining problems where they don't exist. I
don't want to just dismiss real problems -- but I don't _see_ real
problems either. Just people like Dave screaming "you broke it for real
users, like Herbert"... and Herbert saying "er, no you didn't really."
So I have to take it with a pinch of salt.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

