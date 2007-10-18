Return-Path: <linux-kernel-owner+w=401wt.eu-S1763041AbXJRKAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763041AbXJRKAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbXJRKAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:00:00 -0400
Received: from s1.mailresponder.info ([193.24.237.10]:2936 "EHLO
	s1.mailresponder.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbXJRJ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:59:59 -0400
Subject: Re: Inquiry data and emulated SG devices
From: Mathieu Fluhr <mfluhr@nero.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <4716B786.80804@garzik.org>
References: <fa.PgEHbZ0E5ogcX8bZwvrUeZB+eJs@ifi.uio.no>
	 <4716B56A.1090501@shaw.ca>  <4716B786.80804@garzik.org>
Content-Type: text/plain
Organization: Nero AG
Date: Thu, 18 Oct 2007 11:59:15 +0200
Message-Id: <1192701555.3247.28.camel@de-c-l-110.nero-de.internal>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 21:31 -0400, Jeff Garzik wrote:
> Robert Hancock wrote:
> > This doesn't seem a very reliable way to identify an IDE device, as all
> > that 0 means is that the device does not claim conformance to any
> > standard. I would think it would be legitimate for an IDE device to put
> > a value like 5 in there as well, if it complies with SPC-4..
> 
> Via the this-doesnt-really-matter-but-it-should-be-noted department:
> 
> According to the latest on t10.org, MMC retroactively permitted SCSI 
> version to be zero, for MMC-compliant USB and ATAPI devices.
> 

Quoting to the latest MtFuji draft (Section 17.7.1):
 "The ANSI Version field shall contain a non-zero value to comply with 
  this version of the Specification for a SCSI logical unit or zero for
  an ATAPI logical unit."


> > In the case of libata though, that appears to be due to this code in
> > drivers/ata/libata-scsi.c:
> > 
> >     /* ATAPI devices typically report zero for their SCSI version,
> >      * and sometimes deviate from the spec WRT response data
> >      * format.  If SCSI version is reported as zero like normal,
> >      * then we make the following fixups:  1) Fake MMC-5 version,
> >      * to indicate to the Linux scsi midlayer this is a modern
> >      * device.  2) Ensure response data format / ATAPI information
> >      * are always correct.
> >      */
> >             if (buf[2] == 0) {
> >                 buf[2] = 0x5;
> >                 buf[3] = 0x32;
> >             }
> > 

This explain a lot... But (Sorry I am not a scsi mid-layer expert) why
faking what the device outputs?

>From the application side, every device is then saw as real SCSI
devices. So from the developer point of view, this is really bad as
afterwards you have no way to optimize your code regarding the original
hardware architecture.


	Mathieu

