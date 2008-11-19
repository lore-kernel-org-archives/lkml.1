Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbYKSDeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbYKSDeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 22:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYKSDd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 22:33:57 -0500
Received: from mailout-venus.uni-duesseldorf.de ([134.99.128.32]:55514 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751597AbYKSDd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 22:33:57 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2008 22:33:56 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 19 Nov 2008 03:33:52 +0100 (CET)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [PATCH 2/3] ide: add ide_[un]lock_hwgroup() helpers
In-reply-to: <200811182116.00351.bzolnier@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Elias Oltmanns <eo@nebensachen.de>
Message-id: <alpine.DEB.1.00.0811190236550.24738@zirkon.biophys.uni-duesseldorf.de>
References: <200811182116.00351.bzolnier@gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	while (!hwgroup->busy) {
> -		hwgroup->busy = 1;
> -		/* for atari only */
> -		ide_get_lock(ide_intr, hwgroup);
> +	while (!ide_lock_hwgroup(hwgroup)) {

Something I've run into while working on the locking stuff: what happens if the 
above ide_lock_hwgroup(hwgroup) sleeps for long enough to trigger the request 
timer? 

I'll think about the ramifications of your patch in the context of what I tested 
WRT unlocking whenever hwgroup->busy is cleared, and get back to you. 

	Michael
