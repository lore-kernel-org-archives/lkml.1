Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbXGFHac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbXGFHac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760218AbXGFHaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:30:24 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:58732 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXGFHaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:30:24 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 09:30:20 +0200
User-Agent: KMail/1.9.7
Cc: Miklos Szeredi <miklos@szeredi.hu>, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, mjg59@srcf.ucam.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051048.46202.oliver@neukum.org> <1183675095.3388.72.camel@localhost.localdomain>
In-Reply-To: <1183675095.3388.72.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707060930.21348.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 6. Juli 2007 schrieb Benjamin Herrenschmidt:
> 
> > There is that.
> > 
> > OK, bite the bullet. Tasks involved in fuse are special. Give them a flag
> > and teach the freezer to put them on ice only after all other task are
> > frozen. In a way they are kernel, there's no use denying that.
> 
> Yet another ugly hack to work around the fact that the freezer cannot
> work reliably ... yuck
> 
> Why not spend that energy fixing drivers to properly block requests
> instead ?

Because we will be unable to escape that job. Let's assume that
we remove the freezer from the STR path. The next complaint would
be that we cannot do STD with fuse. "Then don't do that" would not
be taken kindly as answer.

So we would be under pressure to remove the freezer from STD, too,
or find a way to make the freezer work. If we'd have to make the freezer
work anyway, we can do it right now.

	Regards
		Oliver
