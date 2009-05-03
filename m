Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZECUqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZECUqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbZECUpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:45:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41071 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757014AbZECUpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:45:53 -0400
Subject: Re: 2.6.30-rc4 Weird messages with ext4
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Panagiotis Papadakos <papadako@csd.uoc.gr>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <49FE0105.6010107@gmail.com>
References: <200905031508.06053.papadako@csd.uoc.gr>
	 <49FE0105.6010107@gmail.com>
Content-Type: text/plain
Date: Sun, 03 May 2009 20:45:51 +0000
Message-Id: <1241383551.5596.116.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-03 at 14:39 -0600, Robert Hancock wrote:
> Panagiotis Papadakos wrote:
> > Hi.
> > 
> > When I connect my ext4 formatted Seagate 1.5 TB USB box,
> > I get the messages of the style:
> > 
> > [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE           
> > [sdb] Sense Key : Illegal Request [current]                     
> > [sdb] Add. Sense: Logical block address out of range 
> > 
> > By the way I am not getting such messages with 2.6.29.
> > 
> > Anyone knows what might be wrong?
> 
> Sounds like something's messing up with the disk size detection, as it 
> gets detected as a 2TB drive. CCing linux-usb and linux-scsi.

There was a screw up in the READ CAPACITY 16 rewrite.  The fix is here:

commit 8f76d151b010980d137bfdc736d1d8f64b489165
Author: Dave Hansen <dave@linux.vnet.ibm.com>
Date:   Tue Apr 21 16:43:27 2009 -0700

    [SCSI] fix sign extension with 1.5TB usb-storage LBD=y
 
It's just gone upstream.

James


