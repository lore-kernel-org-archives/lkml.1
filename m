Return-Path: <linux-kernel-owner+w=401wt.eu-S1764355AbXJOBkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764355AbXJOBkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 21:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbXJOBko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 21:40:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050AbXJOBkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 21:40:42 -0400
Date: Mon, 15 Oct 2007 02:26:21 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
       Guido Guenther <agx@sigxcpu.org>, Kevin Corry <kevcorry@us.ibm.com>,
       stable@kernel.org
Subject: Re: [2.6.24 PATCH 02/25] dm io:ctl use constant struct size
Message-ID: <20071015012621.GD10006@agk.fab.redhat.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
	Guido Guenther <agx@sigxcpu.org>, Kevin Corry <kevcorry@us.ibm.com>,
	stable@kernel.org
References: <20071012170509.GM24157@agk.fab.redhat.com> <200710130016.29937.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710130016.29937.arnd@arndb.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 12:16:29AM +0200, Arnd Bergmann wrote:
> This change seems rather bogus, you're changing the ABI just to work
> around a bug in the compat_ioctl layer. Why not just do the compat
> code the right way, like the patch below?

The underlying ABI is not changing, I hope - the trailing padding in the
struct should not affect the processing of the data by dm, and I see no
reason to continue maintaining the fiction that the 32-bit and 64-bit
ioctls are in some way incompatible with each other when they aren't
AFAIK.

And yes, a follow-up patch can clean up our use of the compatibility
mechanism, going a little bit further than the patch you attached, I
hope.

Alasdair
-- 
agk@redhat.com
