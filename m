Return-Path: <linux-kernel-owner+w=401wt.eu-S964770AbXCSPNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964770AbXCSPNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965862AbXCSPNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:13:19 -0400
Received: from mail.suse.de ([195.135.220.2]:56579 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964770AbXCSPNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:13:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning
Date: Mon, 19 Mar 2007 16:13:04 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200703191611.13849.jesper.juhl@gmail.com>
In-Reply-To: <200703191611.13849.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703191613.04223.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  
> -		device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
> +		err = device_create_file(&floppy_device[drive].dev, &dev_attr_cmos);
> +		if (err)
> +			printk(KERN_WARNING "Unable to create sysfs attribute "
> +				"file for floppy device: %s\n", 
> +				floppy_device[drive].name);

That change looks pretty useless. Either the error should be handled correctly
by bailing out or the warn_unused_results should be dropped.

-Andi
