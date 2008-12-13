Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbYLMXTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbYLMXTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYLMXSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:18:44 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:4549 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYLMXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:18:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=lR+G9VtDqP++MlxlJ3ns2O90lqmNRtXBPIIqnQacvqHAboix2vFxuyTf3jEnlzTMDS
         9oKxKRuOY+H7XOFgq9nOe732CQk2a37D957ugOk4ICzkxere61W7L22yCGDIXzdNgpUE
         Q2tVYazAfOYhnDhutNTTGnwAqc8W1/5Zr8BVM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [PATCH 2/3] ide: add ide_[un]lock_hwgroup() helpers
Date: Sun, 14 Dec 2008 00:15:51 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Elias Oltmanns <eo@nebensachen.de>
References: <200811182116.00351.bzolnier@gmail.com>  <alpine.DEB.1.00.0811190236550.24738@zirkon.biophys.uni-duesseldorf.de>
In-Reply-To: <alpine.DEB.1.00.0811190236550.24738@zirkon.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812140015.51978.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Sorry for the late reply. ]

On Wednesday 19 November 2008, Michael Schmitz wrote:
> > -	while (!hwgroup->busy) {
> > -		hwgroup->busy = 1;
> > -		/* for atari only */
> > -		ide_get_lock(ide_intr, hwgroup);
> > +	while (!ide_lock_hwgroup(hwgroup)) {
> 
> Something I've run into while working on the locking stuff: what happens if the 
> above ide_lock_hwgroup(hwgroup) sleeps for long enough to trigger the request 
> timer? 

AFAICS this happens before the hwgroup timeout timer is armed and IDE is not
using block layer request timers yet so we should be fine here..

Thanks,
Bart
