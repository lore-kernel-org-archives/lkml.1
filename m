Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbXGFHcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbXGFHcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbXGFHcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:32:32 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:59295 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbXGFHcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:32:31 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 09:32:30 +0200
User-Agent: KMail/1.9.7
Cc: Miklos Szeredi <miklos@szeredi.hu>, pavel@ucw.cz, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <E1I6XFM-0001ek-00@dorka.pomaz.szeredi.hu> <1183676751.3388.96.camel@localhost.localdomain>
In-Reply-To: <1183676751.3388.96.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707060932.31345.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 6. Juli 2007 schrieb Benjamin Herrenschmidt:
> > Yes, fuse could handle being frozen there.  However that would only
> > solve part of the problem: an operation waiting for a reply could be
> > holding a VFS mutex and some other task may be blocked on that mutex.
> > 
> > How would you solve freezing those tasks?
> 
> That task is implicitely frozen... but the kernel doesn't know it and
> thus the freezer timeouts or fails or deadlocks or whatever.
> 
> The freezer could be made to ignore tasks that are sleeping in the
> kernel assuming that if they go out of it, they'll ultimately reach
> do_signal and freeze, but that means they can potentially still issues
> IOs which is what the freezer tries to avoid ...
> 
> Or the kernel could start tracking dependencies, but then, good luck
> implementing that crap.

Do we need dependencies? Don't we know that fuse can deadlock only
on a limited number of locks in VFS?

	Regards
		Oliver

