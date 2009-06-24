Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZFXHI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZFXHI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbZFXHIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:08:19 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:64897 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbZFXHIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=nWy9Zg86itZk6A4GQF8L4TcXPS7TFGn/p3ObcbFvVFjkxr9WeZN3S6U22YJ/BDxXpu
         yy/y/Ryj7CvYoCR1Oa3bi1hfJsO2oRdUmZuCAmFC983qpZrbY9/fkES2MCj4TJ9OXroO
         RqSdaI44D2dtfTRW9IWrch4LAHJInLhaWMSys=
Date: Wed, 24 Jun 2009 09:08:13 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [patch 2/6] ide: fix ide_kill_rq() for special
	ide-{floppy,tape} driver requests
Message-ID: <20090624070813.GA21999@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	David Miller <davem@davemloft.net>, bzolnier@gmail.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	htejun@gmail.com
References: <200906232326.06830.bzolnier@gmail.com> <20090623.161611.139291300.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090623.161611.139291300.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:16:11PM -0700, David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 23 Jun 2009 23:26:06 +0200
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: fix ide_kill_rq() for special ide-{floppy,tape} driver requests
> > 
> > Such requests should be failed with -EIO (like all other requests
> > in this function) instead of being completed successfully.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > Untested, you may try pinging Borislav and/or Tejun about possible
> > testing if you would like to verify the patch before applying.
> 
> This must be tested in some way.  I can see this potentially
> breaking something.
> 
> Especially this is true because ide_complete_rq() does it's
> "complete whole request right now" logic for error <= 0.
> 
> Borislov/Tejun, can either of you test this code path with this
> change applied?  I'd very much appreciate it.

Yep, I'll give the whole series a whirl in a while.

-- 
Regards/Gruss,
    Boris.
