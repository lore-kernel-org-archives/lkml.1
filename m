Return-Path: <linux-kernel-owner+w=401wt.eu-S965179AbZLQPXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179AbZLQPXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965130AbZLQPXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:23:08 -0500
Received: from 007.netroom.de ([194.0.247.207]:23390 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965016AbZLQPXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:23:07 -0500
Message-ID: <4B2A4CD1.1070004@draisberghof.de>
Date: Thu, 17 Dec 2009 16:22:57 +0100
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Dan Williams <dcbw@redhat.com>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <200912171402.42168.oliver@neukum.org> <4B2A3312.104@draisberghof.de> <200912171536.44220.oliver@neukum.org>
In-Reply-To: <200912171536.44220.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum schrieb:

> Am Donnerstag, 17. Dezember 2009 14:33:06 schrieb Josua Dietze:
>> If you are thinking about the two specific devices at hand
>> there is no need to tell them apart. Same IDs on plugin, same
>> switching procedure, different IDs on return, different drivers
>> take care.
> 
> How do you issue an eject command without a /dev/sgX node?


You're thinking of handling one device in the kernel and the other 
one (same ID, same switching procedure) on the outside?

Well, as I said, you'd have to "filter" additional data (USB 
model/manufacturer etc., SCSI_INQUIRY strings). But obviously you 
would need to have the data of the two devices to note the differences.

BTW, usb_modeswitch does not need SCSI device nodes, because it 
talks to the USB device directly via the bulk message layer once the 
endpoints are up. Slight advantage over "eject".


Cheers,
Josua

