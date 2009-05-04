Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZEDV7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZEDV7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 17:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZEDV6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 17:58:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44349 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZEDV6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 17:58:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: compat ioctl32 for /dev/snapshot?
Date: Mon, 4 May 2009 23:58:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: "Linux-kernel" <linux-kernel@vger.kernel.org>
References: <49FEB572.4010909@msgid.tls.msk.ru>
In-Reply-To: <49FEB572.4010909@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905042358.56943.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 May 2009, Michael Tokarev wrote:
> Is there any reason why 32-bit uswsusp &Friends does not work
> on 64bits kernel?
> 
> For one, 32bits s2disk produces the following when trying to
> suspend:
> 
>   ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12} arg(ff853554) on /dev/snapshot
>   ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000805) on /dev/snapshot
> 
> this is coming from:
> 
>      error = ioctl(dev, SNAPSHOT_SET_SWAP_AREA, &swap);
>      if (error && !offset)
>              error = ioctl(dev, SNAPSHOT_SET_SWAP_FILE, blkdev);
> 
> but I guess (just guess!) that other SNAPSHOT_* operations will
> also fail the same way.
> 
> Is there a reason why those are not in compat_ioctl?

The user land hasn't been designed with that in mind.  You'd most likely have
to modify it too.

Thanks,
Rafael
