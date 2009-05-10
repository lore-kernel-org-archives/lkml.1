Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZEJVho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZEJVho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbZEJVgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:36:12 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:44286 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbZEJVgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=EccK9jxP8c6gflvNA1lFAt1LQzsFUBOc/F30YPAzQmXW8StpA9N7Mazw05KQswx0Za
         AETDgvd/8vmzV1gsFuH1gFp2HcE9SKmADQOMF5QbDPJHO+drIpDstfsJEQLoBaDt/pnq
         IwTSUVoib/StU7abQvI93yHOtZEXNqIEl2m30=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [RFC PATCH 0/12] ide-atapi remove pc->buf
Date: Sun, 10 May 2009 23:32:24 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905102332.24775.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 09 May 2009 09:45:20 Borislav Petkov wrote:
> Hi Bart,
> 
> Here's an assortment :) of ide patches touching stuff here and there.
> I've been working on those for a while and initial testing shows no
> problems. Among the changes is a first attempt to remove the 64 byte
> buffer embedded in each packet command sent to an ide drive. Also, some
> ireason handling unification is there along with other minor stuff.

Generally looks good but needs some fixes (see my other mails).

[ also: if you are re-posting any patches please always indicate whether
  (and how) they were changed ]

> This is based ontop of
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-sector-and-data_len
> 
> and I'm more than open to suggestions on the logistics of merging those
> (how/when/on top of whose branch/who picks them up/do we want to hit the
> .31 merge window or do more testing?/etc) after being reviewed.
> 
> 
>  drivers/ide/ide-atapi.c        |  145 +++++++++++++++++++++++------------
>  drivers/ide/ide-cd.c           |   69 +++--------------
>  drivers/ide/ide-floppy.c       |   53 ++++++-------
>  drivers/ide/ide-floppy_ioctl.c |   43 ++++++-----
>  drivers/ide/ide-tape.c         |  168 +++++++++++++++++++---------------------
>  include/linux/ide.h            |   18 +----
>  6 files changed, 238 insertions(+), 258 deletions(-)

Good question, how's about:

Once tj/block-unify-sector-and-data_len is in block/for-2.6.31 and your tree
is ready I will pull it into the separate branch.  This branch can be then
pulled into ide/for-next or into new ide/all branch (replacing ide/for-next
in linux-next).

This means that I'll have to synchronize merge window merges with Jens but
this is needed already and shouldn't be a problem.

If somebody [ Tejun/Jens: I'm talking to you :) ] has a better idea how to
handle this please stand-up.

Thanks,
Bart
