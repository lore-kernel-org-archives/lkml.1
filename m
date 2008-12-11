Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYLKJGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYLKJGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 04:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYLKJFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 04:05:55 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:65102 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYLKJFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 04:05:53 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 5/6] kvm-s390: use register_virtio_root_device()
Date: Thu, 11 Dec 2008 10:05:49 +0100
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
References: <1228931096.5384.63.camel@blaa> <1228931139-12956-4-git-send-email-markmc@redhat.com> <1228931139-12956-5-git-send-email-markmc@redhat.com>
In-Reply-To: <1228931139-12956-5-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812111005.49597.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 10. Dezember 2008 schrieb Mark McLoughlin:
> This is basically a no-op change, since it does exactly the
> same thing as s390_root_dev_register() when the caller isn't
> a module.

Ok, I gave it a short test and it seems to work.
Some comments: I agree with your comment in patch0, that a generic 
device_register_root() function might be useful. 

> --- a/drivers/s390/kvm/kvm_virtio.c
> +++ b/drivers/s390/kvm/kvm_virtio.c
[...]
> -	kvm_root = s390_root_dev_register("kvm_s390");
> +	kvm_root = register_virtio_root_device("kvm_s390");
[...]
> -		s390_root_dev_unregister(kvm_root);
> +		unregister_virtio_root_device(kvm_root);

You can now remove the include <asm/s390_rdev.h>
