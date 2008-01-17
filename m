Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYAQHZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYAQHZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYAQHYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:24:52 -0500
Received: from hs-out-0708.google.com ([64.233.178.242]:30311 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751132AbYAQHYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:24:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nB71/FQXQcwT+qhQDtQUldd7G3cgLQBUXPVZKYxP4+iJcUWqp7JXTJWDdKzg379UTRGP5NXrgM4a5fdQ1yvLunsFwsn6mUBtriiV1ymzYoe3rNNSjCvy/poHjZww7NVXNVzuIBLqiaY5nkWZ1HOxIpTbrVolW4gb4RyCV4uwXWM=
Message-ID: <a8e1da0801162324r2cd82684iede3fc8c2f8c391c@mail.gmail.com>
Date: Thu, 17 Jan 2008 15:24:50 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Gabor Gombas" <gombasg@sztaki.hu>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>, "Tejun Heo" <htejun@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, kay.sievers@vrfy.org,
       "Greg KH" <greg@kroah.com>, "Marcel Holtmann" <marcel@holtmann.org>,
       davem@davemloft.net
In-Reply-To: <20080116230646.GB6715@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080107210024.GA13537@boogie.lpds.sztaki.hu>
	 <20080108133215.GA15814@boogie.lpds.sztaki.hu>
	 <478490D2.5050902@gmail.com>
	 <20080110011117.GA3968@darkstar.te-china.tietoenator.com>
	 <20080111230929.GA7052@boogie.lpds.sztaki.hu>
	 <a8e1da0801132305s4f0c3d7asa268382bb6e44777@mail.gmail.com>
	 <20080114135228.6b9a8da2@gondolin.boeblingen.de.ibm.com>
	 <20080115015741.GB2780@darkstar.te-china.tietoenator.com>
	 <20080116010205.GA2970@darkstar.te-china.tietoenator.com>
	 <20080116230646.GB6715@boogie.lpds.sztaki.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 7:06 AM, Gabor Gombas <gombasg@sztaki.hu> wrote:
> Hi,
>
> On Wed, Jan 16, 2008 at 09:02:05AM +0800, Dave Young wrote:
>
> > The rfcomm tty device will possibly retain even when conn is down,
> > and sysfs doesn't support zombie device moving, so this patch
> > move the tty device before conn device is destroyed.
> >
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> This seems to work, both the oops and the hang are gone. I get these
> messages in syslog when the Bluetooth link hangs and I want to kill pppd
> with "poff":
>
> Jan 16 23:55:59 twister kernel: unregister_netdevice: waiting for ppp0 to become free. Usage count = 1
> Jan 16 23:56:09 twister kernel: unregister_netdevice: waiting for ppp0 to become free. Usage count = 1
>
> But a "killall -9 pppd" seems to help and then the re-connect (after the
> phone got power-cycled) works.

Weird, I guess "device_move(dev, NULL) two times" cause the problem.

Anyway, device_move should check the old_parent and new_parent , if
they equal to each other then just return.

Am I right?

>
>
> Gabor
>
> --
>      ---------------------------------------------------------
>      MTA SZTAKI Computer and Automation Research Institute
>                 Hungarian Academy of Sciences
>      ---------------------------------------------------------
>
