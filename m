Return-Path: <linux-kernel-owner+w=401wt.eu-S1762551AbYA1UcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762551AbYA1UcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYA1UbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:31:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762086AbYA1UbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:31:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Mon, 28 Jan 2008 21:28:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       Mika =?iso-8859-1?q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <479E3519.4070105@goop.org> <479E35DB.2010702@zytor.com>
In-Reply-To: <479E35DB.2010702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282128.56335.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> > H. Peter Anvin wrote:
> >>  and we already have to have code to synchronize the PGDs on !PAE and 
> >> the PMDs on Xen (although that was supposedly getting fixed).
> > 
> > No, I don't have any plans there.  Xen will continue to require 
> > non-shared kernel pmd, at least for a 32-bit host.  I think the point is 
> > that nothing that requires an identity mapping will work under Xen 
> > anyway, so Xen just doesn't care about this case.
> > 
> 
> Still makes it a special case, not just for this.

In fact swsusp creates its own temporary page tables for restoring the last
part of the image.  Please have a look at
arch/x86/kernel/suspend_*_64.c and the files in arch/x86/power (most
importantly suspend.c).

Thanks,
Rafael
