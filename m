Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbZEPXhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbZEPXhn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZEPXhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:37:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753451AbZEPXh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:37:29 -0400
Date: Sat, 16 May 2009 16:36:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Larry Finger" <Larry.Finger@lwfinger.net>,
       linux-wireless@vger.kernel.org
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
Message-Id: <20090516163610.8a012268.akpm@linux-foundation.org>
In-Reply-To: <385Pu-agh7M.A.SU.iYzDKB@chimera>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
	<385Pu-agh7M.A.SU.iYzDKB@chimera>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009 21:20:45 +0200 (CEST) "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
> Subject		: Page allocation failures with b43 and p54usb
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2009-04-29 21:01 (18 days old)
> References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> Handled-By	: Johannes Berg <johannes@sipsolutions.net>
> 
> 

Well..  order-1 GFP_ATOMIC allocations are unreliable.  The networking
code should hanlde the situation and recover.  I assume that is
happening in this case?

Perhaps we did something in that code after 2.6.29 which increased the
frequency of the order-1 allocation attempts?  Maybe earlier kernels
used order-0 all the time?  Those are much more reliable.

