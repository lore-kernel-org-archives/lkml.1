Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYJQQum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYJQQum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYJQQu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:50:27 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:4427 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbYJQQu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=UshecmhJZTU6wOx9K6i+i6eI7hccSLp5mIRM4Q3vMHyGgcotpwGYE58l0olvXOtC/U
         u/ugY6AtiODi0D89oGuHAa1m64okEOJtgS0n6AVheq240ykpORVI5Sqg7D6OHdd+J9cJ
         +0BLxx6EROAFeTQ+2BGXk9SPM+OJNKqUq9CX0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: gshan <gshan@alcatel-lucent.com>
Subject: Re: how to limit number of sectors each time
Date: Fri, 17 Oct 2008 18:47:00 +0200
User-Agent: KMail/1.9.10
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <48F6B51B.2000408@alcatel-lucent.com> <20081016061808.GS19428@kernel.dk> <48F6DD54.70004@alcatel-lucent.com>
In-Reply-To: <48F6DD54.70004@alcatel-lucent.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810171847.00687.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-ide@ to cc:, please use it for ATA questions ]

On Thursday 16 October 2008, gshan wrote:
> 
> > (please never send out html only emails, it's considered very bad style
> > on this list)
> >
> > Sounds like you need a quirk/blacklist entry for that drive, if it
> > doesn't support 0x00 as meaning 256 sectors. If you are using libata,
> > you can add a ATA_HORKAGE_MAX_SEC_128 entry to ata_device_blacklist[] in
> > drivers/ata/libata-core.c
> >   
> I'm using IDE driver instead of HD driver.

Then you need to add check for this device to ide_disk_setup()
(prior to blk_queue_max_sectors() call) in drivers/ide/ide-disk.c.

Thanks,
Bart
