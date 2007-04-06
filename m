Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbXDFVEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbXDFVEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbXDFVEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:04:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:34667 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbXDFVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rUbqtjak30hUN2Rvr271vIoF+Jk1ZPiI37C8gm8ZiF2gmDUTRXfix+1VT91Occi4z7o8ux01g1e31wu3h5nDmtbB8ViVPSwecran3r3lYeD9ZK/Ga1NNwj5QDLVpvA2T9WxqOhpKztgm4odzbxX1+ijVUqg/0kecpAB4BA6gCOg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Suleiman Souhlal <ssouhlal@freebsd.org>
Subject: Re: [PATCH] Correctly prevent IDE timer expiry function to run if request was already handled
Date: Fri, 6 Apr 2007 22:51:09 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070406173603.GA82722@freefall.freebsd.org>
In-Reply-To: <20070406173603.GA82722@freefall.freebsd.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704062251.09350.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 06 April 2007, Suleiman Souhlal wrote:
> It is possible for the timer expiry function to run even though the
> request has already been handled: ide_timer_expiry() only checks that
> the handler is not NULL, but it is possible that we have handled a
> request (thus clearing the handler) and then started a new request
> (thus starting the timer again, and setting a handler). 
> 
> A simple way to exhibit this is to set the DMA timeout to 1 jiffy and
> run dd: The kernel will panic after a few minutes because
> ide_timer_expiry() tries to add a timer when it's already active.
> 
> To fix this, we simply add a request generation count that gets
> incremented at every interrupt, and check in ide_timer_expiry() that
> we have not already handled a new interrupt before running the expiry
> function.
> 
> Signed-off-by:	Suleiman Souhlal <suleiman@google.com>

applied, thanks for fixing this
