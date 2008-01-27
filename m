Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbYA0TeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbYA0TeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbYA0TcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:9274 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbYA0TcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GeFLB37Nw45LnyJ2wQOvPgf5xtckLZlww0RE17mE6lsatGlKgybToTLzTGqCwGEqpYr+UpVdbSOcAlg8dCkGUJf9frZpa41Xltkvfi3TAQBoAJiAqrGp/G9fjxjAtL3l5n9U6341/ax1nSwmarmSFFKMRVTW4aMd3UyReIuIrco=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 08/32] ide-tape: remove struct idetape_capabilities_page_t
Date: Sun, 27 Jan 2008 17:46:34 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801271746.34587.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> All those 2-byte values denoting the different capabilities are being written to
> the local copy of the caps buffer without being converted to big endian for
> simplicity of usage and shorter code later.  Also, we add some comments stating
> which are the fields of the caps page in question in order to alleviate the
> cryptic pointer casting exercises as in e.g. idetape_get_mode_sense_results().
> 
> There should be no functional changes resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied

> ---
>  drivers/ide/ide-tape.c |  143 +++++++++++++++++++-----------------------------
>  1 files changed, 57 insertions(+), 86 deletions(-)

[...]

> -	tape->capabilities = *capabilities;		/* Save us a copy */
> -	if (capabilities->blk512)
> +	memcpy(&tape->caps, caps, 20);
> +	if (!!(caps[7] & 0x02))
>  		tape->tape_block_size = 512;
> -	else if (capabilities->blk1024)
> +	else if (!!(caps[7] & 0x04))
>  		tape->tape_block_size = 1024;
> +

I removed needless "!!" and extra newline while merging the patch.
