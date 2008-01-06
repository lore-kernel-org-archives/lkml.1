Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYAFRJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYAFRJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYAFRJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:09:27 -0500
Received: from [212.12.190.12] ([212.12.190.12]:47444 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753375AbYAFRJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:09:26 -0500
From: Al Boldi <a1426z@gawab.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
Date: Sun, 6 Jan 2008 20:07:31 +0300
User-Agent: KMail/1.5
Cc: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <200801051546.SAA08947@raad.intranet> <200801060803.27101.a1426z@gawab.com> <4780E814.4050405@s5r6.in-berlin.de>
In-Reply-To: <4780E814.4050405@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801062007.31516.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Al Boldi wrote:
> > Sam Ravnborg wrote:
> >> And that requires you to use select only to select symbols with
> >> no dependencies.
> >>
> >> In this case we do not know if BLOCK is enabled or not.
> >
> > Good point!  How about we solve it like this:
> >
> >   	menuconfig USB_STORAGE
> >   	tristate "USB Mass Storage support"
> > -	depends on USB && SCSI
> > +	depends on USB && BLOCK
> > +	select SCSI
>
> Still wrong. SCSI also needs HAS_DMA and SCSI_DMA.

I don't think so.  SCSI selects SCSI_DMA, it doesn't depend on it.  So it's 
safe to select SCSI here, as libata does it the same way.


Thanks!

--
Al

