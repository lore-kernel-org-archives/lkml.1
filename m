Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbXGEUh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbXGEUh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759872AbXGEUht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:37:49 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:58336 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759809AbXGEUhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:37:48 -0400
Subject: Re: [SCSI] SD driver question
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <468BCE5C.6000707@googlemail.com>
References: <468BCE5C.6000707@googlemail.com>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 15:37:46 -0500
Message-Id: <1183667866.3448.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-04 at 18:44 +0200, Gabriel C wrote: 
> Is there any reason why sd is printing the driver informations for each 
> disk twice in dmesg ?

Yes, it's because of the genhd revalidate rework done by Al Viro in the
block device revalidation path.  The problem is that we need to run a
disk revalidate early on in sd bringup to get all the necessary
information ... the gendisk code then does a disk revalidate to read the
partition table, resulting in the two identical sets of messages being
printed.  The best fix anyone could suggest was to try to suppress the
messages of the first one using some sort of per scsi_disk flag ...
however, no-one's very keen on this approach.

James


