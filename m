Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZG3VrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZG3VrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZG3VrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:47:07 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:47967 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZG3VrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:47:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=atEr0t1ui0TdavhdVuNO2ecVkyGhtrqj+53xrMsXTxSFfzPNFGVkW08UWbvp2EhyOl
         IHIZzdL6HH8eoiqtxvktLPMXLrc7k3OcDaBKwB7HEIWc60TgD4kJ2oUjTOnwwp0wWWw5
         5xoSCIKQG0sjOavng4rhiXXCBi4MOJwVR4H4o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] pcnet32: VLB support fixes
Date: Thu, 30 Jul 2009 23:46:25 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090722-04415-ge5aa24a-dirty; KDE/4.2.4; i686; ; )
Cc: Don Fry <pcnet32@verizon.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
       corbet@lwn.net, eteo@redhat.com, Julia Lawall <julia@diku.dk>
References: <200907302317.52648.bzolnier@gmail.com> <4A721163.7030700@garzik.org>
In-Reply-To: <4A721163.7030700@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907302346.26017.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 July 2009 23:32:19 Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pcnet32: VLB support fixes
> > 
> > VLB support has been broken since at least 2004-2005 period as some
> > changes introduced back then assumed that ->pci_dev is always valid,
> > lets try to fix it:
> > 
> > - remove duplicated SET_NETDEV_DEV() call
> > 
> > - call SET_NETDEV_DEV() only for PCI devices
> > 
> > - check for ->pci_dev validity in pcnet32_open()
> > 
> > [ Alternatively we may consider removing VLB support but there would not
> >   be much gain in it since an extra driver code needed for VLB support is
> >   minimal and quite simple. ]
> > 
> > This takes care of the following entry from Dan's list:
> > 
> > drivers/net/pcnet32.c +1889 pcnet32_probe1(298) warning: variable derefenced before check 'pdev'
> > 
> > Reported-by: Dan Carpenter <error27@gmail.com>
> > Cc: corbet@lwn.net
> > Cc: eteo@redhat.com
> > Cc: Julia Lawall <julia@diku.dk>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > PS I still keep the original cc: list from the smatch thread -- please let
> > me know if you don't want to be spammed.. ;-)
> > 
> >  drivers/net/pcnet32.c |   12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> ACK -- the patch is correct AFAICS -- but would it not be better to have 
> a struct device for the VLB device?

Sure, such addition would be needed for sysfs support on VLB devices..

> We have capability to create struct device for isa and eisa, so VLB is 
> quite doable.
> 
> 	Jeff, who converted old-ISDN ISA+EISA+PCI drivers to
> 	      hotplug model, once upon a time

..and it seems that you've the needed experience! :)
