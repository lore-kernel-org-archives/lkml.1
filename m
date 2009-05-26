Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZEZMwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZEZMwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZEZMwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:52:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51707 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752802AbZEZMwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:52:36 -0400
Date: Tue, 26 May 2009 13:53:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Message-ID: <20090526135343.5bcaa92b@lxorguk.ukuu.org.uk>
In-Reply-To: <200905261423.40117.bzolnier@gmail.com>
References: <200905252344.11826.bzolnier@gmail.com>
	<20090525233643.0a47e950@lxorguk.ukuu.org.uk>
	<200905260106.13705.elendil@planet.nl>
	<200905261423.40117.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please note that no fancy sysfs support was needed to prevent the problem:
> both stacks (ide & libata) support HDIO_DRIVE_TASK ioctl which can be used
> to execute commands needed to retrieve/change HPA setting.

Wrong. You need sysfs support because you may not be able to retrieve the
HPA settings after the drive has removed them. You also need a trigger of
some form because the block layer needs to see the volume resized and it
doesn't snoop the innards of the ATA command structure.
 
> Moreover the (much needed) work from Tejun doesn't help a tiny bit in case
> of people migrating their *working* setups from IDE to libata (at least
> in distro upgrade case this could have been handled by distro installer but
> see above) and hitting the compatibility issue mentioned in bug #13365.

Fedora handled it with clear documentation at the time. I'm not sure how
other distros handled it back then but given the patch was written by
Ubuntu folk I suspect they knew about it too 8)
