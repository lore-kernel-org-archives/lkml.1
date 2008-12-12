Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYLLPLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYLLPLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 10:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbYLLPLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 10:11:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:51334 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbYLLPLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 10:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ezJRrWns4zXGSTil/VA+NKqzn0GxuOI1TSGZHSaY8jllBR6GQ+sYwEjEINN0VbQoC7
         AbiJpxUGToRqsh99sTgR/aT5IaniGPQ9yfg4r/I0b0tzjVi8VOuBcZmNAZtNSNZAYCIZ
         3qPf0mgNJOiMawz7FKoLEGVyU67NnCFGWEnkg=
Message-ID: <2f11576a0812120711l130e07c3x94ff3b1e64959edf@mail.gmail.com>
Date: Sat, 13 Dec 2008 00:11:39 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49426C16.6040108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211202923.330F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081211113646.GI23742@kernel.dk>
	 <20081211204006.3312.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081212075844.GH23742@kernel.dk> <49426C16.6040108@redhat.com>
X-Google-Sender-Auth: dee7c9a2ec1830d1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Me neither, lets ask the originator of the patch. Rik, why is
>> unevictable lru an option?
>
> I think we had some reasons to keep it as a separate config
> option during development, but nowadays we might as well
> put it all just under CONFIG_SWAP...

I'm sad ;)

To move mlocked file cache page to unevictable list is useful although
swapless embedded device.

Actually, number of scanning pages of reclaim is calculated by number
of pages in list.
if unevictable page stay in evictable list a lot, reclaim logic can
calculate wrong scanning number.
