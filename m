Return-Path: <linux-kernel-owner+w=401wt.eu-S1762536AbZCXQV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762536AbZCXQV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762132AbZCXQV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:21:27 -0400
Received: from stinky.trash.net ([213.144.137.162]:37981 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761153AbZCXQVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:21:24 -0400
Message-ID: <49C9087C.5070907@trash.net>
Date: Tue, 24 Mar 2009 17:21:16 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
CC: netdev@vger.kernel.org, linux-hotplug@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Network Device Naming mechanism and policy
References: <20090324154617.GA16332@auslistsprd01.us.dell.com>
In-Reply-To: <20090324154617.GA16332@auslistsprd01.us.dell.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch wrote:
> 2) udev may have rules to change the device names.  This is most often
>    seen in the '70-persistent-net.rules' file.  Here we have
>    additional challenges:
> 
> ...
> 
>    c) udev may not always be able to change a device's name.  If udev
>       uses the kernel assignment namespace (ethN), then a rename of
>       eth0->eth1 may require renaming eth1->eth0 (or something else).
>       Udev operates on a single device instance at a time, it becomes
>       difficult to switch names around for multiple devices, within
>       the single namespace.

I would classify this as a bug, especially the fact that udev doesn't
undo a failed rename, so you end up with ethX_rename. Virtual devices
using the same MAC address trigger this reliably unless you add
exceptions to the udev rules.

You state that it only operates on one device at a time. If that is
correct, I'm not sure why the _rename suffix is used at all instead
of simply trying to assign the final name, which would avoid this
problem.
