Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbYCDNvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbYCDNvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbYCDNvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:51:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:27260 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbYCDNvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:51:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GrSJQta/BYnCUFrckSHl0JtnVXK55AYldS79KlDQjLM1obqKKxcYrXd9T/PQJCNK81PEFZxn4Tuy7w00y5QFQKAZLrG3P3qZlM/urF43IfGSmw9rR9Tb5Q25PPN77Li22S2KMxrdWfbHTJxS/qxcEYJrJkf0+QuhWMQI8uWR8WQ=
Message-ID: <47CD53BA.5040908@gmail.com>
Date: Tue, 04 Mar 2008 22:50:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <20080304093536.GH6704@kernel.dk>	<1204634238.5997.5.camel@homer.simson.net>	<47CD4355.4050401@gmail.com> <20080304223006A.tomof@acm.org>
In-Reply-To: <20080304223006A.tomof@acm.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> Aiee... device going down after timing out on READ_DISC_INFO.  That's
>> gruesome.  Can you please try the other patches?
> 
> Tejun, I thought that libata needs a fix for sum(sg) != rq->data_len. No?

The extra_len you added to qc->nbytes should be it.  The only other
place to pay attention is the ATAPI transfer chunk size and your patch
seems to get it right.

> Now Jens' git tree should work with all the non libata stuff, ide,
> firewire, bsg, etc. But I'm not sure about libata.

With the second patch, all others should be fine no matter what.  I'll
go check libata part again.

Thanks.

-- 
tejun
