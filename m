Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYH0Unq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYH0Unq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYH0Unj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:43:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:4076 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYH0Uni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DLL8Q8mDQb/GkeXlcHLnB+xNypcM/PTP5aU62n9Wb2Rqlxj2TwqDTyQY/E7p4R1dfN
         WBiNIHuJe4/ICZmCstsZgMBYwzcyhhJv1Wa3OOHsLCabfkaNRTgCpzwdmvrTXNOvZjUn
         3OK0MDF8Rwm4sAoFevYUBO1dQVyvvTLrSJnOw=
Date: Thu, 28 Aug 2008 00:45:11 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       hjk@linutronix.de
Subject: Re: [PATCH, RFC] uio BKL removal
Message-ID: <20080827204511.GA31638@x200.localdomain>
References: <20080826171532.2414c7a2@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826171532.2414c7a2@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 05:15:32PM -0600, Jonathan Corbet wrote:
> UIO: BKL removal
> 
> Remove the BKL from the UIO driver, and add complete locking where needed
> to serialize idr accesses.

> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -47,6 +47,9 @@ static struct uio_class {
>  	struct class *class;
>  } *uio_class;
>  
> +/* Protect idr accesses */

You can rename it to uio_idr_mutex (it's mutex, dammit!) and put next to
uio_idr and avoid comment ;-) Or if locking around _pre_get() isn't
necessary you can actually make it spinlock ;-) Anyway, put it close.

> +static DEFINE_MUTEX(minor_lock);

Indeed, BKL protects nothing because of GFP_KERNEL allocation.

