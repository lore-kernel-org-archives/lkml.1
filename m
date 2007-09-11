Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbXIKXI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbXIKXI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 19:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760632AbXIKXIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 19:08:19 -0400
Received: from 50-178.0-85.cust.bluewin.ch ([85.0.178.50]:46604 "EHLO
	spock.one.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759396AbXIKXIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 19:08:18 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 19:08:18 EDT
Date: Wed, 12 Sep 2007 00:59:32 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Paulo Marques <pmarques@grupopie.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] video: uvesafb: Add X86 dependency.
Message-ID: <20070911225932.GA12223@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070911081752.GA19495@linux-sh.org> <46E67EFD.2040902@grupopie.com> <20070911115346.GA23493@linux-sh.org> <46E687ED.9000802@grupopie.com> <20070911123159.GA23692@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070911123159.GA23692@linux-sh.org>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 09:31:59PM +0900, Paul Mundt wrote:

> > Anyway, I think it is up to Michal to decide if we should remove the 
> > kernel support for other archs, or let it stay a bit more while working 
> > on solving the v86d side of things. So I'll just step aside now....
> > 
> Once v86d is fixed up to get at the ROM directly and the driver uses MMIO
> directly, I don't see a problem with unrestricting it. For the time being
> however, the build is both broken, and the emulator it uses won't run on
> anything but x86, so I see no reason not to add a Kconfig dependency that
> reflects this until such a time where it's no longer true.
> 
> At least if there's a set of restrictions on something fairly generic,
> they tend to be visible, and they also tend to get fixed up over time. We
> should however not enable something generically which at the moment is
> very much tied to a single platform. Later patches can remove the
> dependency at such a time that that assertion no longer holds true.

Just to clear things up: yes, at the moment v86d supports only
x86 and amd64 (aka x86_64) and yes, supporting other arches is
possible and planned.  The main limiting factors as far as this
is concerned are the little amount of my free time and the fact
that I don't currently have access to non-x86 hardware.

Please note that the kernel part (i.e. uvesafb) is meant to be
generic (it currently uses VGA IO ports on non-x86, which is a
bug and for which a patch will follow) and support or lack thereof
for a specific arch should be dependent on v86d only.

That being said, I think that having a kernel dependency 
tracking the development status of userspace code is generally
a bad idea.

Best regards,
-- 
Michal Januszewski                              JID: spock@im.gentoo.org
Gentoo Linux Developer                    http://people.gentoo.org/spock

