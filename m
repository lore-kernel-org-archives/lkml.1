Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZDFVL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZDFVL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZDFVLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:11:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:28755 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZDFVLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=U3+/zFNvxRbwDFf+N8KifrdyKWCIzoaOe6TzOSWCA6vdYy2KNVB18OHFWNdrfSCiKV
         zbu8gUgeG+pMagtBW0/TYxJsq7mTucP/UlngzM32MBI45kPjINbOG+GJffgGOi9chwLo
         EAaqca8t9xXmZ2k2bnU+nM8eQv+ldoVYMpqHM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] xsysace: Fix dereferencing of cf_id after hd_driveid removal
Date: Mon, 6 Apr 2009 22:58:10 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090405083649.1640.31018.stgit@localhost.localdomain>
In-Reply-To: <20090405083649.1640.31018.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904062258.10946.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009, Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Commit 4aaf2fec718f6fbf38668edf733a0ab09a49cab1 (xsysace: make it
> 'struct hd_driveid'-free) converted the cf_id member of 'struct
> ace_device' from a 'struct hd_driveid' to a u16 array.  However,
> references to the base of the structure were still using the '&'
> operator.  When the address was used with the ata_id_u32() macro, the
> compiler used the size of the entire array instead of sizeof(u16) to
> calculate the offset from the base address.
>  
> This patch removes the use of the '&' operator from all references of
> cf_id to fix the bug and remove future confusion.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Thanks for quickly spotting & fixing it.
