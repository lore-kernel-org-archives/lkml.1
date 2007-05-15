Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbXEOXaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbXEOXaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760592AbXEOXaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:30:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:41485 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760455AbXEOXaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oD9Y4zT8xccFXuWz9cZ6Djyga3U7FJLiqvn8rdYq2Nx3fIpssN2REUmju2mkibaKIVB6bOlL9VU2G/1PGGs04GW2CmYOKzSEEWybjZm1C/YVyZV5qI3LnYlxeeOdtwB01WiUnSPROywinvVWz6HIzG1+89K12MS1O/Ye+gDAvXw=
Message-ID: <6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
Date: Wed, 16 May 2007 01:29:59 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Jeff Zheng" <Jeff.Zheng@endace.com>
Subject: Re: Software raid0 will crash the file-system, when each disk is 5TB
Cc: "Ingo Molnar" <mingo@elte.hu>, "Neil Brown" <neilb@suse.de>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo, Neil, linux-raid added to CC]

On 16/05/07, Jeff Zheng <Jeff.Zheng@endace.com> wrote:
> Hi everyone:
>
>         We are experiencing problems with software raid0, with very
> large disk arrays.
> We are using two 3ware disk array controllers, each of them is connected
> 8 750GB harddrives. And we build a software raid0 on top of that. The
> total capacity is 5.5TB+5.5TB=11TB
>
> We use jfs as the file-system, we have a test application that write
> data continuously to the disks. After writing 52 10GB files, jfs
> crashed. And we are not able to recover it, fsck doesn't recognise it
> anymore.
> We then tried xfs, same application, lasted a little longer, but gives
> kernel crash later.
>
> We then reconfigured the hardware array, this time we configured two
> disk array from each controller, than we have 4 disk arrays, each of
> them have 4 750GB harddrives. Than build a new software raid0 on top of
> that. Total capacity is still the same, but 2.75T+2.75T+2.75T+2.75T=11T.
>
> This time we managed to fill the whole 11T data without problem, we are
> still doing validation on all 11TB of data written to the disks.
>
> It happened on 2.6.20 and 2.6.13.
>
> So I think the problem is in the way on software raid handling very
> large disk, maybe a integer overflow or something. I've searched on the
> web, only find another guy complaining the same thing on the xfs mailing
> list.
>
> Anybody have a clue?
>
>
> Jeff
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
