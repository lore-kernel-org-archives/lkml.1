Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYJXHw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYJXHw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYJXHwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:52:49 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:15195 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYJXHws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HQUeDWBRZGs23BByiq6XEIqwDZHOpp4cm++plgIWZYPzh83pNn8pIppFXqUBqHlyy9
         096tyLbjo+pgxur+VGHO9OVfX9970ZdPvUkMnm/RLkzAr6wsiHk1+PPiXojOJFPB36W1
         FPNVW3rXtPVZlfGKGg4qJW6IlZHTJwbAHLZOc=
Message-ID: <807b3a220810240052n6a8b41b0x1ea9c88124b3f5f8@mail.gmail.com>
Date: Fri, 24 Oct 2008 13:22:46 +0530
From: "Nikanth K" <nikanth@gmail.com>
To: "device-mapper development" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 11/13] dm: enable request-based dm
Cc: jens.axboe@oracle.com, agk@redhat.com,
       James.Bottomley@hansenpartnership.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, "Nikanth Karthikesan" <knikanth@suse.de>
In-Reply-To: <20080912.104634.08318008.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	 <20080912.104634.08318008.k-ueda@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 8:16 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> This patch enables request-based dm.
>
> o Request-based dm and bio-based dm coexist, since there are
>  some target drivers which are more fitting to bio-based dm.
>  Also, there are other bio-based devices in the kernel
>  (e.g. md, loop).
>  Since bio-based device can't receive struct request,
>  there are some limitations on device stacking between
>  bio-based and request-based.
>
>                     type of underlying device
>                   bio-based      requeset-based
>   ----------------------------------------------
>    bio-based         OK                OK
>    request-based     NG                OK
>

So will some configurations would become impossible, if a target is
made request-based and bio-based one is removed. Hope both
types of targets would co-exist and would be selectable for sometime.

>  The device type is recognized by the queue flag in the kernel,
>  so dm follows that.
>
> o The type of a dm device is decided at the first table loading time.
>  Until then, mempool creations are deferred, since mempools for
>  request-based dm are different from those for bio-based dm.
>  Once the type of a dm device is decided, the type can't be changed.
>
> o Currently, request-based dm supports only tables that have a single
>  target.

Barrier support should be straight forward?

Thanks
Nikanth Karthikesan
