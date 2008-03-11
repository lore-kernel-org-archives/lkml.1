Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYCKTYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYCKTYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYCKTXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:23:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:59114 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYCKTXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=S7yTAaKnlz7lwizVx4Xlvl+ZDwdVKEDazTN/vSwlFSaXCuQrAvQIaqL0XnrYqltprXj4qMFelMwrOgkEfy4oYdMywrQcWOcLv5uL4FfA4hMQAcgl2SwN2GmP9dXys19/rUw4T6diDzw4PLwP5rVyN2v3dzlr+3ixkZiy0FqWzFA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Build Failure] 2.6.25-rc5-mm1 Build fails with allmodconfig probe_4drives undefined
Date: Tue, 11 Mar 2008 20:36:07 +0100
User-Agent: KMail/1.9.9
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       apw@shadowen.org
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D68126.40109@linux.vnet.ibm.com> <20080311111958.c0d3188d.akpm@linux-foundation.org>
In-Reply-To: <20080311111958.c0d3188d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803112036.08007.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008, Andrew Morton wrote:
> On Tue, 11 Mar 2008 18:25:02 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> >   MODPOST 2279 modules
> > ERROR: "probe_4drives" [drivers/ide/ide-core.ko] undefined!
> 
> Caused by ide-mm-ide-add-ide-4drives-host-driver-take-3.patch.  Applying
> that patch alone to current mainline causes the above error after i386
> `make allmodconfig'.
> 
> Just exporting the symbol doesn't fix it, so something funny is going on.

toolchain?  [ standard F7 system w/ updates here ]

> probe_4drives should not be initialised to zero.
> 
> probe_4drives should not be declared extern in drivers/ide/ide.c - please
> declare it in a header which is included by the definition site and by all
> users.

I was aware of the warnings and this was only temporary (it is already fixed
by to-be-posted-today patch which removes deprecated "idex=" kernel parameters
and makes _all_ probe_* variables static).

Thanks,
Bart
