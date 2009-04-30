Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbZD3WJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbZD3WJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZD3WJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:09:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51596 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbZD3WJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:09:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: in_suspend and __nosave
Date: Fri, 1 May 2009 00:09:07 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@mit.edu>
References: <20090430203000.GA10999@uranus.ravnborg.org>
In-Reply-To: <20090430203000.GA10999@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905010009.07935.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 April 2009, Sam Ravnborg wrote:
> Hi Rafael & Linus.

Hi,

> While unifying vmlinux.lds for x86 I stumbled
> over the .data.nosave section.
> 
> Searching a bit I found only a single user:
> 
> swsusp.c:int in_suspend __nosavedata = 0;
> 
> Do we really needs all this complexity for this single integer?
> We have this section defined in several arch lds files.
> 
> I understand that in_suspend is special as in that we do not
> want the value restored while resuming.
> But is there no other way to do so today?

On x86-64 we can probably get rid of it, a little code rework is needed for
this purpose.  Unfortunately some more work is required to do the same
thing on x86-32.

> All I want is to kill a lot from the vmlinux.lds files.

Well, removing the __nosavedata is on my todo list, but not on the top of it.

> It also occur to me that only: x86, powerpc, and sh
> implement pfn_is_nosave() which I think is the only
> place where we decide if we want to save a page or not.
> 
> But we define the .data.nosave section in following
> architectures:
> arm, m32r, mips, mn10300, parisc, s390 in addition
> to the above archs that define pfn_is_nosave().
> Is this something to be cleaned up?

Yes, it is.

Thanks,
Rafael
