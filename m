Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbZD1O5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbZD1O5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZD1O5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:57:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:54741 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbZD1O5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:57:40 -0400
Date: Tue, 28 Apr 2009 07:51:44 -0700
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] driver: make dev_set_name(, NULL) work
Message-ID: <20090428145144.GA8352@suse.de>
References: <49E8FD0B.2050308@zytor.com> <49E96731.1000501@kernel.org> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain> <49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de> <ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com> <1240086446.2411.9.camel@poy> <20090418203718.GD30144@elte.hu> <49EA4EB9.2030307@kernel.org> <49F6B1E6.7050008@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F6B1E6.7050008@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 12:36:06AM -0700, Yinghai Lu wrote:
> 
> while looking dev_set_name() calling, there is one
> 	dev_set_name(&dev->dev, NULL)
> to used to try to free the device name, before kfree that device.

What's wrong with that?

> need to move the check for device_add in
> | commit 8a577ffc75d9194fe8cdb7479236f2081c26ca1f
> | Author: Kay Sievers <kay.sievers@vrfy.org>
> | Date:   Sat Apr 18 15:05:45 2009 -0700
> |
> |    driver: dont update dev_name via device_add path
> from kobject_set_name_vargs to kobject_add_vargs instead.
> 
> in kobject_set_name_vargs will check if fmt is NULL.
> 
> actually we need to use dev_set_name(,NULL) later on failing path
> and release to prevent leaking

Are you sure?

confused,

greg k-h
