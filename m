Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbZDKHSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbZDKHSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZDKHSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:18:24 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53229 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZDKHSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NmhMccz6bTkeGZyPy61pO2P0SjTy+KhvLsgjBEzT8vXcZfV241UA0gLVxQ/JddPRqR
         V3uhxo2crIBNOwh5wIFWMIUe+TS7evXBvMa0zkURQBZrMFn3BDBq+Bwl/pRcysX4Q3EA
         ay0tPvbp6FLoAnqGutVKactrvk92Qh2EWWIyA=
MIME-Version: 1.0
In-Reply-To: <1239365545-10356-8-git-send-email-philipp.reisner@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-2-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-3-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-4-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-5-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-6-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-7-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-8-git-send-email-philipp.reisner@linbit.com>
Date: Sat, 11 Apr 2009 09:18:21 +0200
Message-ID: <e2e108260904110018y74f39f1et39006ef9cd8f28d7@mail.gmail.com>
Subject: Re: [PATCH 07/14] DRBD: internal_data_structures
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline void drbd_kobject_uevent(struct drbd_conf *mdev)
> +{
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,10)
> +#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,15)
> +       kobject_uevent(disk_to_kobj(mdev->vdisk), KOBJ_CHANGE, NULL);
> +#else
> +       kobject_uevent(disk_to_kobj(mdev->vdisk), KOBJ_CHANGE);
> +       /* rhel4 / sles9 and older don't have this at all,
> +        * which means user space (udev) won't get events about possible changes of
> +        * corresponding resource + disk names after the initial drbd minor creation.
> +        */
> +#endif
> +#endif
> +}

There exist scripts which accept a kernel patch and a kernel version
and remove all code that does not apply to the specified kernel
version. Maybe it's a good idea to run the DRBD code through such a
script before posting it for review.

Bart.
