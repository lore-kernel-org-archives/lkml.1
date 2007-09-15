Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbXIOQVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbXIOQVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 12:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXIOQVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 12:21:21 -0400
Received: from quail.cita.utoronto.ca ([128.100.76.6]:48406 "EHLO
	quail.cita.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbXIOQVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 12:21:20 -0400
Date: Sat, 15 Sep 2007 12:20:56 -0400
From: Robin Humble <rjh@cita.utoronto.ca>
To: Jeff Garzik <jeff@garzik.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage. Move away from char device ioctls.
Message-ID: <20070915162056.GA31576@lemming.cita.utoronto.ca>
References: <20070914185429.GA9439@2ka.mipt.ru> <46EADC02.9070409@garzik.org> <20070915135633.GA19482@lemming.cita.utoronto.ca> <46EBEDA4.3070103@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EBEDA4.3070103@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 10:35:16AM -0400, Jeff Garzik wrote:
>Robin Humble wrote:
>>On Fri, Sep 14, 2007 at 03:07:46PM -0400, Jeff Garzik wrote:
>>>I've been waiting for years for a smart person to come along and write a 
>>>POSIX-only distributed filesystem.
>>it's called Lustre.
>>works well, scales well, is widely used, is GPL.
>>sadly it's not in mainline.
>Lustre is tilted far too much towards high-priced storage,

many (most?) Lustre deployments are with SATA and md raid5 and GigE -
can't get much cheaper than that.

if you want storage node failover capabilities (which larger sites often
do) or want to saturate an IB link then the price of the storage goes
up but this is a consequence of wanting more reliability or performance,
not anything to do with lustre.

interestingly, one of the ways to provide dual-attached storage behind
a failover pair of lustre servers (apart from buying SAS) would be via
a networked-raid-1 device like Evgeniy's, so I don't see distributed
block devices and distributed filesystems as being mutually exclusive.
iSER (almost in http://stgt.berlios.de/) is also intriguing.

>and needs 
>improvement before it could be considered for mainline.

quite likely.
from what I understand (hopefully I am mistaken) they consider a merge
task to be too daunting as the number of kernel subsystems that any
scalable distributed filesystem touches is necessarily large.

roadmaps indicate that parts of lustre are likely to move to userspace
(partly to ease solaris and ZFS ports) so perhaps those performance
critical parts that remain kernel space will be easier to merge.

cheers,
robin
