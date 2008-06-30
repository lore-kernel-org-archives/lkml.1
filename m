Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbYF3Hgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbYF3Hgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYF3Hgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:36:42 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:53194 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYF3Hgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:36:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=In-Reply-To:Received:Date:Cc:To:From:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=Nnfs/flS3Ir96Me9Ba9rmcIbDrBev79sCI7qLTF+yqp587fmkfUOuJ+tNFgo8cp6n
	mwxB+UusyKqCkr1F3YLme+W/RiPbG2tPY5a+f1qIqvSLBDDf+aVxpL7VUB5AHc9N63/
	zg7JNYaErrKPbqeDOw5BERloEXWYbvENee8zMhM=
In-Reply-To: <6e8c2b4453be89dba35e0595c9cfcf0a@kernel.crashing.org>
Date: Mon, 30 Jun 2008 09:18:10 +0200 (CEST)
Cc: hpa@zytor.com, John.Linn@xilinx.com, arnd@arndb.de, drepper@redhat.com,
       matthew@wil.cx, john.williams@petalogix.com,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linuxppc-dev@ozlabs.org,
       =?us-ascii?Q?Michal=20Simek?= <monstr@monstr.eu>, vapier.adi@gmail.com,
       microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
       will.newton@gmail.com
To: =?us-ascii?Q?Segher=20Boessenkool?= <segher@kernel.crashing.org>
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?Re=3A=20=5BPATCH=2019=2F60=5D=20microblaze=5Fv4=3A=20checksum=20support?=
Mime-Version: 1.0
Message-Id: <4117.6640-711-1819091302-1214810290@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii";
	format=flowed
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm5<127987843>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Segher,

you find bug because there is microblaze asm code in generic folder. 
Big thanks. I'll fix it and I'll look at parameters too.

Michal

> +static inline unsigned int
> +csum_tcpudp_nofold(unsigned long saddr, unsigned long daddr, unsigned 
> short len,
> +		unsigned short proto, unsigned int sum)
> +{
> +	__asm__("add %0, %4, %1\n\t"
> +		"addc %0, %4, %2\n\t"
> +		"addc %0, %4, %3\n\t"
> +		"addc %0, %4, r0\n\t"
> +		: "=d" (sum)
> +		: "d" (saddr), "d" (daddr), "d" (len + proto),
> +		"0"(sum));

"sum" should use an earlyclobber, i.e.  "=&d"(sum)  , since some
inputs are used after %0 is first written to.

Also, you can use "+" instead of "=" to say the argument is both
input and output, and get rid of %4, if you like.


Segher



