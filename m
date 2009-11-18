Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZKRO1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZKRO1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZKRO1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:27:37 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:33512 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187AbZKRO1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:27:14 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: Use of usb_find_interface in open is racy
Date: Wed, 18 Nov 2009 15:27:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Russ Dill <russ.dill@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <f9d2a5e10911171306r416eaf2k45c3256370e82eda@mail.gmail.com> <alpine.LRH.2.00.0911181141030.31913@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0911181141030.31913@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181527.18791.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 18. November 2009 11:41:25 schrieb Jiri Kosina:
> > User space receives the hotplug event for the class device, makes the
> > device node and notifies another program that opens the device node.
> > The program opens the device node which calls into usb_open and then
> > skel_open. skel_open calls usb_find_interface. usb_find_interfaces
> > searches the klist_devices of skel_driver, finds no device associated
> > with the minor number and returns NULL. skel_open returns -ENODEV.
> > 
> > Control returns to really_probe and really_probe calls driver_bound
> > which adds the device to the list of devices associated with
> > skel_driver (klist_devices).
> > 
> > I'm not sure what the right way to solve this is. A call to
> > wait_for_device_probe() in the skel_open call before calling
> > usb_find_interface fixes the problem, but it is a rather large hammer.
> 

Device core code is hard to follow, but I tried.
How about simply covering all of usb_register_dev() with minor_rwsem?

	Regards
		Oliver
