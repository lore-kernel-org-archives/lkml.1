Return-Path: <linux-kernel-owner+w=401wt.eu-S1765003AbXKOBqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765003AbXKOBqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXKOBqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:46:12 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:1235 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbXKOBqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:46:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hwtikHa9krL7wDzdL+XjRs4H22E9OvTAVrobHtKBZozHse2/bVlEpGYADhiQKsR49qQ95M5a3w8Sj2QItwZUUApDUy3jVt63j/WNg9TaKN2WYjaTKCccjtnOSo45umwQdmAlCbCSX0KG/t9Uy8tE2hGbYRpiJdsRCR7m8QhYHO8=
Message-ID: <473BA4D8.508@gmail.com>
Date: Thu, 15 Nov 2007 10:46:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/2] sata_nv: don't use legacy DMA in ADMA mode
References: <473A7628.3010907@shaw.ca> <473BA447.6090909@gmail.com>
In-Reply-To: <473BA447.6090909@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> If so, can you please add that switching into register mode is okay as
> long as there's no other ADMA commands in flight and add
> WARN_ON((qc->flags & ATA_QCFLAG_RESULT_TF) && link->sactive)?

More accurately, link->sactive test can be substituted with
(ap->qc_allocated & ~(1 << qc->tag)).

-- 
tejun
