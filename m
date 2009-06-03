Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZFCIEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZFCIEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbZFCIDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:03:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:40846 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047AbZFCIDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XOq+ow6OjY86slO7uh6U2QdoaLer/VDHoWF/fP0HCAD+AVW3g2RsnDOM1lLsvhZaee
         yhz+VYsWRMAECOT16TQ1k96rt1SDQanr8hzssKt+JFxU+kBXSDgHAmoW35zDBUDACS2D
         W8jiXm5oVv2A/mfC3bZQF64mpJnqK3Y0J9wow=
MIME-Version: 1.0
In-Reply-To: <20090602100018.415b1dfc@lxorguk.ukuu.org.uk>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
	 <1243926700-30485-4-git-send-email-vapier@gentoo.org>
	 <20090602100018.415b1dfc@lxorguk.ukuu.org.uk>
Date: Wed, 3 Jun 2009 04:03:46 -0400
Message-ID: <8bd0f97a0906030103i64bc1a9duc5aeaea7bd3f8365@mail.gmail.com>
Subject: Re: [PATCH 04/11] Blackfin SPORT UART: fix overrun errors
From: Mike Frysinger <vapier.adi@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 05:00, Alan Cox wrote:
> On Tue,  2 Jun 2009 03:11:33 -0400 Mike Frysinger wrote:
>> From: Cliff Cai <cliff.cai@analog.com>
>>
>> Push the ty_flip_buffer_push() call from the IRQ handler to a timer so as
>> to improve performance and decrease likelihood of overruns.
>
> This should have no effect on a modern kernel.

well, we wouldnt be making changes if we werent seeing data overruns today

> There is 64K of queueing between you and the ldisc nowdays.

i dont think that really matters ... we do too much work in the
interrupt and so we miss new data

> Furthermore unless you set tty->low_latency the kernel already basically
> does this aggregation for you as the buffer push queues stuff for the ldisc
> to wake up and process.

i guess we could try setting the low_latency bool instead and see if
that fixes things
-mike
