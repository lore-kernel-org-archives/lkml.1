Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZEIQEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZEIQEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbZEIQEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:04:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:23907 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZEIQEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SOA217WcGffAyyoPs5DOAT+xSmODRE64DvNu5Jz9s3opEoW46GBmPPC+rfBAszglCh
         wZvoDXVokGf/31aRxbYhNVwU4Eh3asIujWfjGM5A1ce1QwjMyoS4XHY1ueBFq7YdDCyR
         ehkH2RWF2WdVtpKbjqmU/rAge/uhVg+N7yoeU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/18] ide: dequeue in-flight request
Date: Sat, 9 May 2009 17:58:39 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@hansenpartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, petkovbb@googlemail.com, sshtylyov@ru.mvista.com,
       oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org,
       Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com,
       zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-2-git-send-email-tj@kernel.org>
In-Reply-To: <1241751256-17435-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905091758.40306.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009 04:53:59 Tejun Heo wrote:
> ide generally has single request in flight and tracks it using
> hwif->rq and all state handlers follow the following convention.
> 
> * ide_started is returned if the request is in flight.
> 
> * ide_stopped is returned if the queue needs to be restarted.  The
>   request might or might not have been processed fully or partially.
> 
> * hwif->rq is set to NULL, when an issued request completes.
> 
> So, dequeueing model can be implemented by dequeueing after fetch,
> requeueing if hwif->rq isn't NULL on ide_stopped return and doing
> about the same thing on completion / port unlock paths.  These changes
> can be made in ide-io proper.
> 
> In addition to the above main changes, the following updates are
> necessary.
> 
> * ide-cd shouldn't dequeue a request when issuing REQUEST SENSE for it
>   as the request is already dequeued.
> 
> * ide-atapi uses request queue as stack when issuing REQUEST SENSE to
>   put the REQUEST SENSE in front of the failed request.  This now
>   needs to be done using requeueing.
> 
> [ Impact: dequeue in-flight request ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: Borislav Petkov <petkovbb@googlemail.com>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
