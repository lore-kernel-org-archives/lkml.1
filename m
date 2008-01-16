Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYAPXG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYAPXG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbYAPXGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:06:49 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:60231 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYAPXGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:06:48 -0500
Date: Thu, 17 Jan 2008 00:06:46 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, kay.sievers@vrfy.org,
       Greg KH <greg@kroah.com>, Marcel Holtmann <marcel@holtmann.org>,
       davem@davemloft.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080116230646.GB6715@boogie.lpds.sztaki.hu>
References: <20080107210024.GA13537@boogie.lpds.sztaki.hu> <47834593.1000506@gmail.com> <20080108133215.GA15814@boogie.lpds.sztaki.hu> <478490D2.5050902@gmail.com> <20080110011117.GA3968@darkstar.te-china.tietoenator.com> <20080111230929.GA7052@boogie.lpds.sztaki.hu> <a8e1da0801132305s4f0c3d7asa268382bb6e44777@mail.gmail.com> <20080114135228.6b9a8da2@gondolin.boeblingen.de.ibm.com> <20080115015741.GB2780@darkstar.te-china.tietoenator.com> <20080116010205.GA2970@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116010205.GA2970@darkstar.te-china.tietoenator.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 16, 2008 at 09:02:05AM +0800, Dave Young wrote:

> The rfcomm tty device will possibly retain even when conn is down,
> and sysfs doesn't support zombie device moving, so this patch
> move the tty device before conn device is destroyed.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

This seems to work, both the oops and the hang are gone. I get these
messages in syslog when the Bluetooth link hangs and I want to kill pppd
with "poff":

Jan 16 23:55:59 twister kernel: unregister_netdevice: waiting for ppp0 to become free. Usage count = 1
Jan 16 23:56:09 twister kernel: unregister_netdevice: waiting for ppp0 to become free. Usage count = 1

But a "killall -9 pppd" seems to help and then the re-connect (after the
phone got power-cycled) works.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
