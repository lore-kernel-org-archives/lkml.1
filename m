Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXEZPNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXEZPNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbXEZPNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:13:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:46260 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbXEZPNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XgOQE4G1D7BSruiII3sTygoBPtDfXJe/2DVPB4JcIFPeKslBKju4z+U777rDraDicKiUwVUg3Nd7128UtMTZ5f4xKOKai2+CRamVdE4ShISPELosyH8WE+C1PUU/AFcaQw8sigv2lm10RdRUw0T7kLfG8y0MT9aVl8PAEhZ7eAQ=
Message-ID: <2c0942db0705260813g6aeedbfepc0afa94ba3550e5b@mail.gmail.com>
Date: Sat, 26 May 2007 08:13:06 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Tommy Vercetti" <vercetti@zlew.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
In-Reply-To: <200705261505.38109@gj-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705261505.38109@gj-laptop>
X-Google-Sender-Auth: cb493464140605a6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Tommy Vercetti <vercetti@zlew.org> wrote:
> I was trying to get answer to my question around, but no one knows.
> I do have DMA turned on, etc, yet - on extensive harddrive operations wait

You may have DMA turned on, but it may be ineffectual if you don't
have the right IDE driver handing your disk.

> time is 90+% , which means that machine is waiting, rather than doing
> something meanwhile. (I guess).

What does hdparm -tT /dev/hda say? If the numbers are reasonable
(~400MB/s for cache reads, ~25MB/s for buffered disk reads), then
you're just doing a lot of seeking on the drive, and that takes a long
time. (Drives can seek about 100 times a second. If every seek reads
only 4k of data, that's 400k of data processed per second, or a lot of
time spent with the CPU waiting on I/O.)
