Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbYIZIx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbYIZIx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYIZIxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:53:45 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58944 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYIZIxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:53:44 -0400
Message-ID: <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Ric Wheeler" <rwheeler@redhat.com>,
       "Christoph Hellwig" <hch@infradead.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, <linux-fsdevel@vger.kernel.org>,
       <dm-devel@redhat.com>, <viro@ZenIV.linux.org.uk>,
       <linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>, <axboe@kernel.dk>,
       <mtk.manpages@googlemail.com>, <linux-kernel@vger.kernel.org>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com>
In-Reply-To: <48DBFD42.6030307@redhat.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Fri, 26 Sep 2008 17:52:35 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6000.16480
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6000.16545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ric Wheeler wrote:
> Christoph Hellwig wrote:
>> On Mon, Sep 08, 2008 at 08:53:37PM +0900, Takashi Sato wrote:
>>
>>> The timeout feature is added to "freeze ioctl" to solve a deadlock
>>> when the freezer accesses a frozen filesystem. And new ioctl
>>> to reset the timeout period is added to extend the timeout period.
>>> For example, the freezer resets the timeout period to 10 seconds every 5
>>> seconds.  In this approach, even if the freezer causes a deadlock by
>>> accessing the frozen filesystem, it will be solved by the timeout
>>> in 10 seconds and the freezer will be able to recognize that
>>> at the next reset of timeout period.
>>>
>>
>> And as with all previous posting I still fundamentally disagree about
>> the need of this functionality.  We don't need a timeout for freezing.
>
> I agree with Christoph here, I think that the timeout is unneeded.

I think that your concern is that the freezer cannot recognize the occurrence
of a timeout and it continues the backup process and the backup data is
corrupted finally.
If the freezer can recognize it by the unfreeze ioctl's errono, will your concern
 be solved?
If so, I will implement it.

Cheers, Takashi

