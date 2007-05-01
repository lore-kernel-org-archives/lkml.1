Return-Path: <linux-kernel-owner+w=401wt.eu-S1031636AbXEAJs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031636AbXEAJs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031638AbXEAJs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:48:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46823 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031636AbXEAJs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:48:56 -0400
Date: Tue, 1 May 2007 10:52:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ismail =?UTF-8?B?RMO2bm1leg==?= <ismail@pardus.org.tr>
Cc: dann frazier <dannf@hp.com>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, support@moxa.com.tw,
       dilinger@debian.org
Subject: Re: old buffer overflow in moxa driver
Message-ID: <20070501105214.078b4326@the-village.bc.nu>
In-Reply-To: <200705010301.34571.ismail@pardus.org.tr>
References: <20070430224829.GI31283@krebs.dannf>
	<20070501000455.2173b1e2@the-village.bc.nu>
	<200705010301.34571.ismail@pardus.org.tr>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > At the point you abuse these calls you can already just load arbitary
> > data from userspace anyway.
> 
> So the possible exploit will only work when run by root, is that what you 
> mean? If so isn't that still a security problem?

To exploit the hole you need CAP_SYS_RAWIO which is the highest
capability of all. CAP_SYS_RAWIO gives you the ability to access hardware
directly so since it checks for CAP_SYS_RAWIO it isn't security.

The patch isn't wrong however and adds some sanity checking so it would
do no harm to send it to Andrew for -mm testing.

Alan
