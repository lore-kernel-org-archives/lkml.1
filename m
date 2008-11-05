Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYKES2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYKES2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYKES2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:28:00 -0500
Received: from www.tglx.de ([62.245.132.106]:41414 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYKES17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:27:59 -0500
Date: Wed, 5 Nov 2008 19:27:44 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Greg KH <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
       Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: only call pgprot_noncached if defined
Message-ID: <20081105182743.GE6382@local>
References: <1225301177-21406-1-git-send-email-vapier@gentoo.org> <20081105113610.GA6382@local> <20081105163334.GA8473@suse.de> <8bd0f97a0811050933m13addb7eiddb963bfdf4d7416@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0811050933m13addb7eiddb963bfdf4d7416@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 12:33:37PM -0500, Mike Frysinger wrote:
> On Wed, Nov 5, 2008 at 11:33, Greg KH wrote:
> > On Wed, Nov 05, 2008 at 12:36:11PM +0100, Hans J. Koch wrote:
> >> There seem to be archs that cannot easily implement a sensible
> >> pgprot_noncached() function, so we should merge this patch. UIO doesn't
> >> compile on these archs right now.
> >
> > No, we should fix those arches to have that function at least NULLed
> > out.  Isn't there only one, Blackfin?  Putting #ifdefs in .c files is
> > not something we really want to do if at all possible.
> 
> that was my question.  this function isnt documented.  if the hardware
> doesnt support it, is the right thing really for the arch to lie to
> drivers and not actually give back cached settings even though it
> asked for non-cached ?

Well, if there's no possibility to map device memory in a non-cached
way, it's very likely you don't want to use UIO at all. If there's a few
seconds between a write and the value actually appearing in the hardware
register, you will certainly don't see the results you expect.

If Blackfin can't mmap non-cached memory, we should make UIO depend on
!BLACKFIN.

Hans
