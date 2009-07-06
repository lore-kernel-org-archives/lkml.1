Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZGFQST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZGFQST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbZGFQSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:18:06 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:40777 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZGFQSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:18:05 -0400
Message-ID: <4A5223B6.1010102@davidnewall.com>
Date: Tue, 07 Jul 2009 01:47:58 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: tridge@samba.org
CC: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
References: <19013.8005.541836.436991@samba.org>	<20090630063102.GB1351@ucw.cz>	<200907012019.53932.rusty@rustcorp.com.au>	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>	<20090701140503.GA21185@mit.edu>	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>	<alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>	<19021.19842.663727.146474@samba.org>	<87hbxu60qm.fsf@devron.myhome.or.jp>	<19021.23231.213863.726785@samba.org>	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>	<19021.26102.80885.330380@samba.org>	<alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>	<19021.31291.642416.956966@samba.org>	<alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>	<19021.63615.450348.192109@samba.org>	<alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr> <19025.63119.656216.431469@samba.org>
In-Reply-To: <19025.63119.656216.431469@samba.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org wrote:
> Hi Jan,
>
>  >  * "cp dscf4160.jpg dscF3011.jpg" does not work - i.e. cam ignores the
>  >    file without error.
>  >    Reason for that is that dscF3011 has an illegal 8.3 name
>
> yep, that's expected. I suggested a possible way of handling this to
> Hirofumi-san (ie. change the case of the name), but he prefers to keep
> things simple for now.
>   

Expected or not, it's a serious bug. If it doesn't canonify the
filename, it should return an error. Lying by returning success is
horridly wrong. And I might just suggest that as people are now
accustomed to typing mixed-case filenames, it's a bug that's likely to
occur more frequently than it might at first seem.
