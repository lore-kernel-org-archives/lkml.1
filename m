Return-Path: <linux-kernel-owner+w=401wt.eu-S968112AbXEHOHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968112AbXEHOHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968107AbXEHOHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:07:07 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46409 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968104AbXEHOHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:07:02 -0400
Date: Tue, 8 May 2007 07:07:53 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
	(PCI_MULTITHREAD_PROBE)
Message-ID: <20070508140753.GB12641@kroah.com>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 03:37:13PM +0200, Cornelia Huck wrote:
> As I wanted to add multithreaded probing for some s390 busses, I
> discovered that the commit above removed the multithreaded probing
> infrastructure again, while just some days before some of my patches
> reworking it had been merged... I thought
> http://marc.info/?l=linux-kernel&m=117591868412593&w=2 meant that we
> should go ahead with per-subsystem multithreaded probing?

Only if it ends up working properly.  The commit you reference above
(which removed the PCI_MULTITHREAD_PROBE option), is fine, pci
multi-threaded probing is still broken as it is a model that PCI drivers
are not yet ready to handle properly yet.

Why do you want it to be enabled again?  It shouldn't affect you doing
multi-threaded probing for some other subsystem.

> (OK, PCI_MULTITHREAD_PROBE should not depend on BROKEN, but on
> EXPERIMENTAL with the reworked probing infrastructure. This got mixed
> up, I can send a patch that changes it.)

No, it turns out that no matter how hard and loud you put the warnings
in the config file help, people will ignore it and enable the option
anyway, and then get mad at you when your machine breaks just like the
config option said it would.

It also upsets other developers who get blamed for bugs that were caused
by this change, not their code, making debugging very difficult.

So it should stay removed for now.

thanks,

greg k-h
