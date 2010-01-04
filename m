Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097Ab0ADGoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab0ADGoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 01:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923Ab0ADGom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 01:44:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51868 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab0ADGol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 01:44:41 -0500
X-Authority-Analysis: v=1.0 c=1 a=wwQKETDKjd0A:10 a=2C6YHBdLAAAA:8 a=VwQbUJbxAAAA:8 a=isTnyV9Sptl3ixQ5CE0A:9 a=2tOOH3SLp59Rpe1X1hoA:7 a=ASOJbh_fxssNnj9BTS8YwqWHndIA:4 a=mJMriH8CDpcA:10
X-Cloudmark-Score: 0
X-Originating-IP: 70.124.57.33
Date: Mon, 4 Jan 2010 00:57:55 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Ashwin Ganti <ashwin.ganti@gmail.com>
Subject: Re: Staging tree status for the .33 kernel merge
Message-ID: <20100104065755.GA26627@hallyn.com>
References: <20091223005447.GA28941@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223005447.GA28941@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
...
> This means, unless someone steps up and starts doing real work (not
> trivial spelling fixes) on the following drivers, they will be removed
> in the future kernel releases.
> 
>  - arlan, netwave, strip, wavelan - wireless drivers mentioned above
>    that are on the way out.  Slated for removal in 2.6.35
>  - hv - Microsoft Hyper V drivers.  The developers again seem to have
>    disappeared, this is getting old. Slated for removal in 2.6.35
>  - p9auth - this will be removed in .34 unless someone steps up.

I think I've decided to try to push it.  I'm working with some patches
at git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux-cr.git
(branch p9auth.jan3.4 is latest).  I'll send patches as I feel they
are ready - so far they pass testcases, but are too new for me to
feel I should push them today.

Ashwin, I'm curious whether you'd think the last patch
(http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/sergeh/linux-cr.git;a=commitdiff;h=1662ba777140a39c21a9b647459d2deab8ffe1ca)
would be a problem with any userspace - but I assume there is no
legacy userspace to really worry about?

Apart from plenty more cleanups, another more fundamental issue to
address is how to stop unused caphash entries from piling up in
memory.  Put a timeout on them?  Let privileged userspace list and
occasionally delete them?  Associate a target task with each entry,
where either the task or its decendent can use the capability, but
if the task dies we free the caphash entry?

-serge
