Return-Path: <linux-kernel-owner+w=401wt.eu-S1760568AbZD1Se7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbZD1Se7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZD1Set
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:34:49 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47058 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZD1Ses (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=idj1qUUpKF81zNEOYOSmUOtwCid/cs0T7AKB8grGeSXncZZiCytHVf5vzXfhaZaaof
         BKIzMghEkq1iR2lgMzypwIdoSETlrSxmq8oUI4yrqxE0rGwPVB3WWROk7GGmsKgA6VWH
         N5fLgL8mcCFCK9SmqREjJlapQoSHZgBmonxNc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCHSET linux-2.6-block#for-2.6.31] block: lld cleanup patches
Date: Tue, 28 Apr 2009 20:38:29 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
References: <1240489553-15724-1-git-send-email-tj@kernel.org> <200904242141.56375.bzolnier@gmail.com> <49F67B87.10103@kernel.org>
In-Reply-To: <49F67B87.10103@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904282038.31075.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009 05:44:07 Tejun Heo wrote:
> Hello, Bartlomiej.
> 
> Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [RFC][PATCH] mg_disk: fix issue with data integrity on error in mg_write()
> > 
> > We cannot acknowledge the sector write before checking its status
> > (which is done on the next loop iteration) and we also need to do
> > the final status register check after writing the last sector.
> > 
> > Fix mg_write() to match mg_write_intr() in this regard.
> > 
> > While at it:
> > - add mg_read_one() and mg_write_one() helpers
> > - always use MG_SECTOR_SIZE and remove MG_STORAGE_BUFFER_SIZE
> > 
> > Cc: unsik Kim <donari75@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> I folded other three patches into my series.  This one looks good to me
> too but unlike others this one actually changes how the driver
> interacts with the device so I think it would be better to wait for
> unsik's ack on this one (I'm pushing out others).

Fine with me and thanks for handling it.  BTW do you still have version this
patch re-synced on top of other changes around?
