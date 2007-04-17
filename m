Return-Path: <linux-kernel-owner+w=401wt.eu-S1031091AbXDQFGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031091AbXDQFGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 01:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbXDQFGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 01:06:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:38627 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbXDQFGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 01:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=j49wXaFxSlR0pWh1/1slWiY7GmyA5pWOxZKrvGxjz7uidUchuGYVRayQGv0afv3G2bv4SWH1F2UGRFl3mvd2WXpSFHueEKqYctcONuK4uefd+6nJ3U5PAcPTw0kfrWy3yk3c2VPLTn6Bib1YLsQwYyF2zUS4a/FNf0uRZ66Un1w=
Message-ID: <462455D7.3050908@gmail.com>
Date: Tue, 17 Apr 2007 14:06:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: maneesh@in.ibm.com
CC: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET #master] sysfs: make sysfs disconnect immediately on
 deletion, take 2
References: <11760923261269-git-send-email-htejun@gmail.com> <20070416082212.GC31874@in.ibm.com>
In-Reply-To: <20070416082212.GC31874@in.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Maneesh.

Maneesh Soni wrote:
> I started looking at these patches and parallely also did some testing on a 
> 8 CPU system. I am using the patches from Greg's tree at
> http://www.kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git/
> 
> I ran following loops parallelly
> 
> # while true; do insmod drivers/net/dummy.ko; sleep 1;rmmod dummy; done
> # while true; do find /sys/class/net/dummy0 | xargs cat; sleep 1; done
> # while true; do umount /sys; sleep 1; mount -t sysfs none /sys; done
> # while true; do find /sys | xargs cat > /dev/null; sleep 1; done
> 
> and got the following oops
> 
> Unable to handle kernel NULL pointer dereference at 000000000000004c RIP:
>  [<ffffffff802935b4>] simple_unlink+0x14/0x5c

Eeek... I'll try to replicate and track down the bug here.  FWIW, SCSI
also oopses if udev is running due to a bug in SCSI open/close handling.

Thanks for testing.

-- 
tejun
