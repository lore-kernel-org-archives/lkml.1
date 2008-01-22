Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYAVRhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYAVRhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYAVRhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:37:05 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:32697 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbYAVRhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:37:03 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mika =?ISO-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <479551FD.5040801@zytor.com>
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>
	 <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	 <47939363.8040603@kolumbus.fi>
	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>
	 <479510CE.7010706@zytor.com>
	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>
	 <479551FD.5040801@zytor.com>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 17:36:41 +0000
Message-Id: <1201023401.5643.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-21 at 18:16 -0800, H. Peter Anvin wrote:
> Ian Campbell wrote:
> > 
> > I'm just preparing to send out a version which uses the native_* way of
> > doing things, its not actually as clean as I would like so I'd be
> > interested to see the ASM variant.
> > 
> 
> This is the asm version I came up with.

I moderately prefer the C version, even if it is in a restricted
environment where care is needed to access global variables. I like that
it avoids multiple copies of the code and also find the structure of
what's going on is more obviously apparent (even to someone who has done
plenty of ASM mode page table frobbing in the past).

Anyhow, I don't feel all that strongly about it so if the opinion of the
early start of day maintainer(s) is strongly in favour of ASM I'll defer
to that.

> This is only the actual 
> assembly part; it doesn't require the (obviously necessary) bootmem 
> adjustments.

Do you mean the native_pagetable_setup_start/done changes? I'm a bit
confused by not requiring obviously necessary changes -- I presume you
just mean that those changes are desirable but should be deferred into a
separate patch?

The C way doesn't inherently require those two changes to happen in the
same patch either -- probably worth splitting out if we go that route.

Ian.

-- 
Ian Campbell
Current Noise: Pelican - Bliss In Concrete

Your life would be very empty if you had nothing to regret.

