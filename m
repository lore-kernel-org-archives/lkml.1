Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZKMLwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZKMLwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZKMLwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:52:39 -0500
Received: from smtp.nokia.com ([192.100.122.233]:33788 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbZKMLwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:52:38 -0500
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
From: "Shargorodsky Atal (EXT-Teleca/Helsinki)" 
	<ext-atal.shargorodsky@nokia.com>
To: ext David VomLehn <dvomlehn@cisco.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "dwm2@infradead.org" <dwm2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mpm@selenic.com" <mpm@selenic.com>
In-Reply-To: <20091112220925.GC28349@dvomlehn-lnx2.corp.sa.net>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
	 <4AFC6711.1090405@windriver.com>
	 <20091112220925.GC28349@dvomlehn-lnx2.corp.sa.net>
Content-Type: text/plain
Date: Fri, 13 Nov 2009 13:50:36 +0200
Message-Id: <1258113036.5987.18.camel@atal-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Nov 2009 11:52:20.0668 (UTC) FILETIME=[C19C9FC0:01CA6457]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 23:09 +0100, ext David VomLehn wrote:
> On Thu, Nov 12, 2009 at 02:50:41PM -0500, Paul Gortmaker wrote:
> > David VomLehn wrote:
> >> Allows annotation of panics to include platform information. It's no big
> >> deal to collect information, but way helpful when you are collecting
> >> failure reports from a eventual base of millions of systems deployed in
> >> other people's homes.
> ...
> > Why hook into panic() directly like this, vs. using the panic
> > notifier list? If you use that, and then put the data handling
> > magic that you need into your own kernel module that knows how
> > to interface with the reporting apps that you have, you can
> > do the whole thing without having to alter existing code, I think.
> 
> I agree--a panic notifier list is probably a better approach.
> 

That's what we currently use:

http://marc.info/?l=linux-kernel&m=125655380512117&w=2

Very simple and does the job.
Requires to rearrange the panic code a bit, though.
Namely, to move notifiers invocation before the call to kmsg_dump().
Dumpers were introduced by Simon Kagstrom here:

http://marc.info/?l=linux-kernel&m=125569530109871&w=2


Regards,
Atal

> David VL
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

