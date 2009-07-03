Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZGCGUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZGCGUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZGCGUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:20:00 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48092 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZGCGT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PKztddKgW3OvZXFJsxR2Noow3idD+I/MMhZit1fTwCqfhefgZp6OQ2Z1rKllyxHawD
         yXvwYMBhhRsYhGavWYnvaDr1PGM1nV6DA1qb7gKao8VP8V7formmho0mJDhU5KCyVU5n
         64UrrV7pbETeJ8/EGLmoLGkMovStOED9FFVws=
Date: Fri, 3 Jul 2009 06:12:13 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090703061213.GA4847@ff.dom.local>
References: <200907030331.32531.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907030331.32531.andres@anarazel.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 03:31:31AM +0200, Andres Freund wrote:
...
> Ok. I finally see the light. I bisected the issue down to
> eea08f32adb3f97553d49a4f79a119833036000a :  timers: Logic to move non
> pinned timers
>
> Disabling timer migration like provided in the earlier commit stops the 
> issue from occuring.
>
> That it is related to timers is sensible in the light of my findings, 
> that I could trigger the issue only when using delay in netem - that is 
> the codepath using qdisc_watchdog...

Andres, thanks for your work and time. It saved me a lot of searching,
because I wasn't able to trigger this on my old box.

Jarek P.
