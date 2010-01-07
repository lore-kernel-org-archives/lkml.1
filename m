Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379Ab0AGRA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0AGRA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309Ab0AGRA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:00:56 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:65394 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab0AGRA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:00:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tzDm6sTvgDmbgU7RbUvUAWFxWDrbTAMIMUfHE5S6PJaXgu6z1jNr51CWB36qMu+CV9
         rLJ34QtKVVRqaZvPUkqg8cqzmbAYuQkDD+gmDjMkJM0lW1UkZIGF3gDEvoe4cFx4mqLL
         FVnSjpyxFSrRYjEaUqdqOXiUXM2fSvhRG3j9c=
MIME-Version: 1.0
In-Reply-To: <20100107143640.GB7664@redhat.com>
References: <4e5e476b1001051348y4637986epb9b56958c738061a@mail.gmail.com>
	 <E1NSq2i-0000wY-00.kirill_nnov-mail-ru@foot.mail.ru>
	 <4e5e476b1001070538y35143cc8me7443f3eb0d377@mail.gmail.com>
	 <20100107143640.GB7664@redhat.com>
Date: Thu, 7 Jan 2010 18:00:54 +0100
Message-ID: <4e5e476b1001070900y4428644bse06d8304cde1a86c@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue 
	merging
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kirill Afonshin <kirill_nnov@mail.ru>, Jeff Moyer <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 3:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Corrado,
>
> How does idle time value relate to flash card being slower for writes? If
> flash card is slow and we choose to idle on queue (because of direct
> writes), idle time value does not even kick in. We just continue to remain
> on same cfqq and don't do dispatch from next cfqq.
>
> Idle time value will matter only if there was delay from cpu side or from
> workload side in issuing next request after completion of previous one.
>
> Thanks
> Vivek
Hi Vivek,
for me, the optimal idle value should approximate the cost of
switching to an other queue.
So, for reads, if we are waiting for more than 1 ms, then we are
wasting bandwidth.
But if we switch from reads to writes (since the reader thought
slightly more than 1ms), and the write is really slow, we can have a
really long latency before the reader can complete its new request.
So the optimal choice would be to have two different idle times, one
for switch between readers, and one when switching from readers to
writers.

Thanks,
Corrado
