Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXKWNYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXKWNYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 08:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXKWNXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 08:23:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:57030 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbXKWNXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 08:23:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f7rmt07VCsNmODO3S5zV6WFelkrArfjBR2hExOgz5NquGtBDnzMZ5UAJiMYGwUxTIQcH3ZhjZO0bFF/OuwtxTzoxsiDLULH8VPgshUiQOJrQQP4DumLRS5NQsSanqBtvMG8Bv5ON3Y+MjiI1EtYzdKLAIse2c4Ob0uYn/nNwoCY=
Message-ID: <e9e943910711230523y2376c908s360bafc19f661d5d@mail.gmail.com>
Date: Fri, 23 Nov 2007 13:23:50 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Timo Sirainen" <tss@iki.fi>
Subject: Re: Unkillable gdb process gets system unusably slow
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1195793695.3843.7.camel@hurina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195793695.3843.7.camel@hurina>
X-Google-Sender-Auth: 48a631d4a6cab990
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/11/2007, Timo Sirainen <tss@iki.fi> wrote:
> Fully reproducible with me. v2.6.23.1 x86-64 SMP kernel, Core 2 CPU, gdb
> v6.6.90.20070912-debian.

Fixed in 2.6.23.2, see discussion starting here:
http://marc.info/?l=linux-kernel&m=119379156819358&w=2

> gdb ./hang
> run
> fr 1
> p (char*)base
>
> p command hangs and the entire system becomes unusably slow. kill -9
> doesn't kill gdb.
>
> /* gcc hang.c -o hang -g -Wall */
> #include <stdio.h>
> #include <string.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <sys/mman.h>
>
> int main(void)
> {
>         int fd;
>         char buf[100];
>         void *base;
>
>         fd = open("hang.tmp", O_RDWR | O_CREAT, 0600);
>         if (fd == -1) perror("open");
>
>         base = mmap(NULL, 100, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
>         if (base == MAP_FAILED)
>                 perror("mmap");
>         memcpy(buf, base, sizeof(buf));
>         return 0;
> }

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
