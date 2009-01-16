Return-Path: <linux-kernel-owner+w=401wt.eu-S937185AbZAPSt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937185AbZAPSt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937090AbZAPSt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:49:26 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45960 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937078AbZAPStY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:49:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=mCyxPntZNXFlBddeaX238wn0R27znNaXFFYSrdNud3Ja9RciTvFYhfdlLHcxkFt5m
	rtoHRVMYmByM/SKGKeKdg==
MIME-Version: 1.0
In-Reply-To: <20090116093101.6d77b69b.akpm@linux-foundation.org>
References: <20090116152721.GA6994@havoc.gtf.org>
	 <20090116093101.6d77b69b.akpm@linux-foundation.org>
Date: Fri, 16 Jan 2009 10:49:19 -0800
Message-ID: <da824cf30901161049n35ae8723ieb5e2fd7fbbdf739@mail.gmail.com>
Subject: Re: [git patches] libata fixes
From: Grant Grundler <grundler@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.144
X-GMailtapped: grundler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 9:31 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
...
>> +static void octeon_cf_tf_read16(struct ata_port *ap, struct ata_taskfile *tf)
>> +{
>> +     u16 blob;
>> +     /* The base of the registers is at ioaddr.data_addr. */
>> +     void __iomem *base = ap->ioaddr.data_addr;
>> +
>> +     blob = __raw_readw(base + 0xc);
>
> why __raw?

Avoid byte swapping. If it's "native" HW on Big Endian platform,
byte swapping isn't needed. If it's working, it's correct.

hth,
grant
