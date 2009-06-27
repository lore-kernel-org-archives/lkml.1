Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbZF0R1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbZF0R1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbZF0R1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:27:11 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34869 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836AbZF0R1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:27:09 -0400
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl,
 COMMAND_SIZE and scsi_device_type
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Boaz Harrosh <bharrosh@panasas.com>,
       Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <1246122359.32198.7.camel@hpdv5.satnam>
References: <1246122359.32198.7.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 12:27:08 -0500
Message-Id: <1246123628.3990.19.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All SCSI patches should be cc'd to the SCSI list

On Sat, 2009-06-27 at 22:35 +0530, Jaswinder Singh Rajput wrote:
> userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
> and scsi_device_type defined in kernel
> 
> fix the following 'make headers_check' warnings:
> 
>   usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
>   usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/scsi/scsi.h |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 084478e..7ba5acf 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -156,9 +156,6 @@ scsi_varlen_cdb_length(const void *hdr)
>  	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
>  }
>  
> -extern const unsigned char scsi_command_size_tbl[8];
> -#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
> -
>  static inline unsigned
>  scsi_command_size(const unsigned char *cmnd)
>  {
> @@ -166,6 +163,13 @@ scsi_command_size(const unsigned char *cmnd)
>  		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);

Even a simple eyeball inspection of this patch shows that the removal of
COMMAND_SIZE above causes this inline function to fail to compile.

If you can't be bothered even to read your own patches or at the very
least compile test them, what makes you think I should bother reading
anything you send in?

James



