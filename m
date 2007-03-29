Return-Path: <linux-kernel-owner+w=401wt.eu-S964791AbXC2CNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbXC2CNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 22:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934306AbXC2CNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 22:13:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:6028 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933973AbXC2CNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 22:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=h+JJb98bJA5crFd57kb9jqiYEYxHuSiQDawQAvAurzDvGM0Wx5bYUhbeUWLS7MElpumbpRin/Fb7PW6TiJTaU9mWtnv2SRW6CfqNikNniHaEb6V1gIOsS0sTNCiMdYIJI6jokQSs+9YbobUKzNQmADMvrdX18VG4M8vTfhwM9Uw=
Message-ID: <460B20D0.7010009@gmail.com>
Date: Thu, 29 Mar 2007 11:13:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [patch 3/3] libata: handle AN interrupt
References: <20070328230108.597741522@intel.com> <20070328164457.a675a7d2.kristen.c.accardi@intel.com>
In-Reply-To: <20070328164457.a675a7d2.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> When we get an SDB FIS with the 'N' bit set, we should send
> an event to user space to indicate that there has been a
> media change.  The ahci host controller will send the
> event via KOBJ_CHANGE uevent.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
>  
> +static void async_notify_thread(struct work_struct *work)
> +{
> +	struct ata_device *atadev =
> +		container_of(work, struct ata_device, async_notify);
> +
> +	/*
> +	 * TBD - who should send this event?  I couldn't find an
> +	 * easy way to map an ata_device to a genhd device, so
> +	 * decided maybe the ata host should send the event and
> +	 * allow user space to figure out what happened?
> +	 */
> +	kobject_uevent(&atadev->ap->host->dev->kobj, KOBJ_CHANGE);
> +}

I don't think this is right.  If you're gonna make media_change_event 
capability generic, you gotta make event delivery generic too.  You can 
make it a genhd event and make genhd supply the interface function, say, 
genhd_notify_media_change() which is then forwarded by SCSI layer.

Thanks.

-- 
tejun
