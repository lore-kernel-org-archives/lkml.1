Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYLKMw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYLKMw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 07:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYLKMwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 07:52:19 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:46259 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbYLKMwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 07:52:18 -0500
Date: Thu, 11 Dec 2008 13:49:22 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Mark McLoughlin <markmc@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 5/6] kvm-s390: use register_virtio_root_device()
Message-ID: <20081211134922.71d6d811@gondolin>
In-Reply-To: <200812111005.49597.borntraeger@de.ibm.com>
References: <1228931096.5384.63.camel@blaa>
	<1228931139-12956-4-git-send-email-markmc@redhat.com>
	<1228931139-12956-5-git-send-email-markmc@redhat.com>
	<200812111005.49597.borntraeger@de.ibm.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 10:05:49 +0100,
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am Mittwoch, 10. Dezember 2008 schrieb Mark McLoughlin:
> > This is basically a no-op change, since it does exactly the
> > same thing as s390_root_dev_register() when the caller isn't
> > a module.
> 
> Ok, I gave it a short test and it seems to work.
> Some comments: I agree with your comment in patch0, that a generic 
> device_register_root() function might be useful. 

Indeed, if this is a simple replacement, we want a generic function.
I'll take a look at the patches.

> 
> > --- a/drivers/s390/kvm/kvm_virtio.c
> > +++ b/drivers/s390/kvm/kvm_virtio.c
> [...]
> > -	kvm_root = s390_root_dev_register("kvm_s390");
> > +	kvm_root = register_virtio_root_device("kvm_s390");
> [...]
> > -		s390_root_dev_unregister(kvm_root);
> > +		unregister_virtio_root_device(kvm_root);
> 
> You can now remove the include <asm/s390_rdev.h>
