Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZFXJpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZFXJpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZFXJpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:45:30 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:64227 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZFXJp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=L5biozny8EpuVZ4xnlrJiznVIeOcoHNDIeVeRgVkfJEZ07Q7ALUVMQjNA3LiVhLen1
         o4L0cTWedHuZM+oRY0yCBaCtXcA+0tO0bfOEsppGd3WNcw/X5xW50yfBkaCtPzIYkTq/
         UVg7NjdsrL+x6udNZeRRlV5NP4e7SBkLVKC+Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 3/6] ide: always kill the whole request on error
Date: Wed, 24 Jun 2009 11:38:00 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, htejun@gmail.com
References: <200906232327.27610.bzolnier@gmail.com> <200906240249.33505.bzolnier@gmail.com> <20090623.234948.121450964.davem@davemloft.net>
In-Reply-To: <20090623.234948.121450964.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906241138.00687.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 08:49:48 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Wed, 24 Jun 2009 02:49:32 +0200
> 
> > On Wednesday 24 June 2009 01:19:04 David Miller wrote:
> >> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> Date: Tue, 23 Jun 2009 23:27:27 +0200
> >> 
> >> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> > Subject: [PATCH] ide: always kill the whole request on error
> >> > 
> >> > * Use blk_rq_bytes() instead of obsolete ide_rq_bytes() in ide_kill_rq()
> >> >   and ide_floppy_do_request() for failed requests.
> >> >   [ bugfix part ]
> >> > 
> >> > * Use blk_rq_bytes() instead of obsolete ide_rq_bytes() in ide_do_devset()
> >> >   and ide_complete_drive_reset().  Then remove ide_rq_bytes().
> >> >   [ cleanup part ]
> >> > 
> >> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> > ---
> >> > 'cleanup part' tested, limited testing with 'bugfix part'
> >> > (using simulated failures of disk fs requests)
> >> 
> >> Considering this alongsize patch #2, it even more begs the
> >> question as to why special requests on floppy and tape were
> >> handled differently.  And that 'error <= 0' test, strange.
> > 
> > TBH I fail to see how it relates to changes present in _this_ patch
> > as no change in _this_ patch affects special tape/floppy requests..
> 
> The previous patch is a prerequesite for this one.  So we should
> discuss them as a whole.  Because if we can't remove the "ide/floppy
> RQ error 0 instead of -EIO" bit, then we don't make these further
> consolidations either.

Untrue, we can easily redo the patch #3 to not be dependent on patch #2.

Do you prefer such version instead?
