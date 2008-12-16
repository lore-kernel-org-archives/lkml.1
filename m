Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbYLPM7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbYLPM7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYLPM6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:58:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:11020 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbYLPM6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:58:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=mMvucG+89uBSRNYj4AELjkR7GEMtMVhuPGsLp2HEk6WHodZTWZ7/sy1a5ohousfxh6
         ZpCVtwIp2Twu9Xq4IW7xr3ROKjnhtIdg1byiKnshbcH+IvP4MoVigbP3Xyk/FEcQQNEI
         BEfGVSRGwX0aMSIuB9NZSx3sbaStrPOqKfV5Q=
Message-ID: <2f11576a0812160458y1c376878vc5fc7f3d208aa344@mail.gmail.com>
Date: Tue, 16 Dec 2008 21:58:52 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [mmotm and linux-next][PATCH] irq: enclose irq_desc_lock_class in CONFIG_LOCKDEP
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>
In-Reply-To: <20081216121815.GA25019@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081216170635.DBB8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081216003428.43d37b6b.akpm@linux-foundation.org>
	 <20081216101827.GB27481@elte.hu> <20081216102340.GA1003@elte.hu>
	 <2f11576a0812160315g3dea988ayfadba2117e172a2c@mail.gmail.com>
	 <20081216112019.GE4299@elte.hu>
	 <2f11576a0812160345t1cca65eg34064dbbcafcd280@mail.gmail.com>
	 <20081216121815.GA25019@elte.hu>
X-Google-Sender-Auth: 7e735f85a905a0a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> or, following #ifdef ?
>>
>> #if defined(CONFIG_SPARSE_IRQ) || defined(CONFIG_TRACE_IRQFLAGS)
>>
>>  /*
>>  * lockdep: we want to handle all irq_desc locks as a single lock-class:
>>  */
>>  static struct lock_class_key irq_desc_lock_class;
>
> instead of increasing the #ifdef jungle, how about removing some? For
> example is this distinction:
>
>> >  #ifndef CONFIG_SPARSE_IRQ
>
> really needed? We should use symmetric lock class annotations, regardless
> of how irq_desc[] is laid out.

it seems make much sense. I'll test your idea tommorow.

thanks.
