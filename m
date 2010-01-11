Return-Path: <linux-kernel-owner+w=401wt.eu-S1750920Ab0AKLZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920Ab0AKLZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 06:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432Ab0AKLZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 06:25:33 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33427 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab0AKLZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 06:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z8mAyjqzoGn0PoVWBDzqcn0yR7NgZUA20TcDAuZvlqgmlHlxqfblo4X7VpC+dg+K0D
         +SrOELdK8q/1w3HVcriNiGImoutYNvvq7Ik+dH/Ri1DGYYH+mT7SFKpvBbsEBuWW6nBw
         fmTE5ac/20uvaakvE5O8gKAiftVIP/XYOKia0=
Message-ID: <4B4B0AA9.5020900@garzik.org>
Date: Mon, 11 Jan 2010 06:25:29 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Corrado Zoccolo <czoccolo@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: NCQ SSDs do not need read queue merging
References: <1262211768-10858-1-git-send-email-czoccolo@gmail.com> <1263157461-12294-1-git-send-email-czoccolo@gmail.com>
In-Reply-To: <1263157461-12294-1-git-send-email-czoccolo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2010 04:04 PM, Corrado Zoccolo wrote:
> NCQ SSDs' performances are not affected by
> distance of read requests, so there is no point in having
> overhead to merge such queues.
>
> Non-NCQ SSDs showed regression in some special cases, so
> they are ruled out by this patch.
>
> This patch intentionally doesn't affect writes, so
> it changes the queued[] field, to be indexed by
> READ/WRITE instead of SYNC/ASYNC, and only compute proximity
> for queues with WRITE requests.
>
> Signed-off-by: Corrado Zoccolo<czoccolo@gmail.com>

That's not really true.  Overhead always increases as the total number 
of ATA commands issued increases.

	Jeff




