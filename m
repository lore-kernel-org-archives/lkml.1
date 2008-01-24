Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbYAXMT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbYAXMT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYAXMTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:19:48 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:11916 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYAXMTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:19:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ee2PngbnqMtlGgsR5AmIkPSaFHm8MksQ7mhvq2vZR8OOQHtTDOl1LgOHp+WgQ85ELPRcomtDRzvn1VpHc3YNcUHxuWafr96L/g9CgCes6j7/AQ9Oi7QsiBnFBN5g8reE+9DTRgf4zUZMt17pHU2k7CqzBRpcFmqnrFmhx6pHKkc=
Message-ID: <cfd9edbf0801240419t669c9d9cl4cf0f821599fc7ad@mail.gmail.com>
Date: Thu, 24 Jan 2008 13:19:45 +0100
From: "=?ISO-8859-1?Q?Daniel_Sp=E5ng?=" <daniel.spang@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 3/8] mem_notify v5: introduce /dev/mem_notify new device (the core of this patch series)
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Marcelo Tosatti" <marcelo@kvack.org>, "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080124132014.1769.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080124132014.1769.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,

On 1/24/08, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> +#define PROC_WAKEUP_GUARD  (10*HZ)
[...]
> +       timeout = info->last_proc_notify + PROC_WAKEUP_GUARD;

If only one or a few processes are using the system I think 10 seconds
is a little long time to wait before they get the notification again.
Can we decrease this value? Or make it configurable under /proc? Or
make it lower with fewer users? Something like:

timeout = info->last_proc_notify + min(mem_notify_users, PROC_WAKEUP_GUARD);

Cheers,
Daniel
