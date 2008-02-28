Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbYB1Pq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbYB1Pq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbYB1PqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:46:18 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:54166 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbYB1PqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:46:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sJcnwHXapzmQffLfU/PoEhcEwOKDivwlN0UWpjA3sg0RIwRT2+GvWutaZG1LZYK1tN4+9HZDTE8mvZsWC3WWmK3LCDbZMjVl3d+AImWBnHRGGYzvsqCXYM1Gs2ut4iMtzZzjClJFVd+1SMHe7FzXkAqAzpOsA93o1NI9Qr+dXXY=
Message-ID: <47C6D73E.4030302@gmail.com>
Date: Fri, 29 Feb 2008 00:46:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] block: fix residual byte count handling
References: <1203839683.17463.9.camel@homer.simson.net> <1204019283.8731.11.camel@homer.simson.net> <1204033003.11828.22.camel@homer.simson.net> <20080226150845.2196bc1a.akpm@linux-foundation.org> <1204079075.26640.8.camel@homer.simson.net> <1204092010.9934.31.camel@homer.simson.net> <1204096025.1623.9.camel@homer.simson.net> <47C6661E.9010504@gmail.com> <1204186800.7362.7.camel@homer.simson.net> <47C675C6.8000904@gmail.com> <20080228153542.GZ6704@kernel.dk>
In-Reply-To: <20080228153542.GZ6704@kernel.dk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> This problem was reported and diagnosed by Mike Galbraith.
> 
> Tejun, this patch isn't much cleaner at all. It really shows the pain of
> these two seperate, yet related, variables.

Not much cleaner compared to what?  I think padding stuff is bound to be
somewhat complex.  It's a nasty thing in nature.  I think ->extra_len is
better than ->raw_data_len because ->extra_len only needs to be updated
where the dirty jobs are done and extra buffer areas are added.  Any
better suggestions?

Thanks.

-- 
tejun
