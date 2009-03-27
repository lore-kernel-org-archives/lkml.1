Return-Path: <linux-kernel-owner+w=401wt.eu-S1763994AbZC0CWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763994AbZC0CWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 22:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934559AbZC0CVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 22:21:31 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:17163 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934500AbZC0CV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 22:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cwy/TgOBLo933IrNUWHPJL2lJxxmpUysClxnqUfdTDKJo3Pjwg9eXtvyOVNLE1LndN
         2zrA++Iu0J6ELlT/2vQ2BHDjcVii5Hn8EEsRru585zZlvs0UclnrPm1D9szgNHUUzdgX
         OCg9yUeH/+Sf/V2Xb1YOGMvhJURrp5m8I35XY=
MIME-Version: 1.0
In-Reply-To: <20090326182519.d576d703.akpm@linux-foundation.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> 
	<20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> 
	<20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> 
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> 
	<20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> 
	<20090326182519.d576d703.akpm@linux-foundation.org>
Date: Thu, 26 Mar 2009 19:21:08 -0700
Message-ID: <72dbd3150903261921k7cf728ebhf331e9965630be7e@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 6:25 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Why does everyone just sit around waiting for the kernel to put a new
> value into two magic numbers which userspace scripts could have set?
>
> My /etc/rc.local has been tweaking dirty_ratio, dirty_background_ratio
> and swappiness for many years.  I guess I'm just incredibly advanced.

The only people who bother to tune those values are people who get
annoyed enough to do the research to see if it's something that's
tunable - hackers.

Everyone else simply says "man, Linux *sucks*" and lives life hoping
it will get better some day.  From posts in this thread - even most
developers just live with it, and have been doing so for *years*.

Even Linux distros don't bother modifying init scripts - they patch
them into kernel instead.  I routinely watch Fedora kernel changelogs
and found these comments in the changelog recently:

* Mon Mar 23 2009 xx <xx@xx.xx> 2.6.29-2
 - Change default swappiness setting from 60 to 30.

* Thu Mar 19 2009 xx <xx@xx.xx> 2.6.29-0.66.rc8.git4
 - Raise default vm dirty data limits from 5/10 to 10/20 percent.

Why are the going in the kernel package instead of /etc/sysctl.conf?
Why is Fedora deviating from upstream? (probably sqlite performance)
Maybe there's a good reason to put them into the kernel - for some
reason the latest kernels perform better with those values where the
previous ones didn't.  But still - why ship those 2 bytes of
configuration in a 75MB package instead of one that could be a
fraction of that size?

Does *any* distro fiddle those bits in userspace instead of patching the kernel?

-Dave
