Return-Path: <linux-kernel-owner+w=401wt.eu-S1765076AbXFGQnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765076AbXFGQnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbXFGQnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:43:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:47920 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbXFGQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S87+OQLjgARlNAqUzcaaaQSpCvBS++TbQmfhEuMJIqF6VFxpJaRtC+xeO62Pr6b5R1pTlENIV4yBatU5XxWIsIcTi3oAzqH843zucy8Etr6mf+MbE92rIE6bQ6bsIdBGulhRN6kkfataT96HrwyWFS1ouRhfJYeEACzyExkOjig=
Message-ID: <787b0d920706070943h6ac65b85nee5b01600905be08@mail.gmail.com>
Date: Thu, 7 Jun 2007 12:43:42 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Badari Pulavarty" <pbadari@us.ibm.com>
Subject: Re: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       ebiederm@xmission.com, torvalds@linux-foundation.org
In-Reply-To: <1181233393.9995.14.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
	 <20070606204432.b670a7b1.akpm@linux-foundation.org>
	 <787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com>
	 <1181233393.9995.14.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Badari Pulavarty <pbadari@us.ibm.com> wrote:

> BTW, I agree with Eric that its would be nice to use shmid as part
> of name instead of forcing to be as inode number. It should be
> possible for pmap to workout shmid from "key" or name. Isn't it ?

It is not at all nice.

1. it's incompatible ABI breakage
2. where will you put the key then, in the inode? :-)

Changing to "SYSVID%d" is no good either. Look, people
are ***parsing*** this stuff in /proc. The /proc filesystem
is not some random sandbox to be playing in.

Before you go messing with it, note that the device number
also matters. (it's per-boot dynamic, but that's OK)
That's how one knows that /SYSV00000000 is not just
a regular file; sadly these didn't get a non-/ prefix.
(and no you can't fix that now; it's way too late)

Next time you feel like breaking an ABI, mind putting
"LET'S BREAK AN ABI!" in the subject of your email?

BTW, I suspect this kind of thing also breaks:
a. fuser, lsof, and other resource usage display tools
b. various obscure emulators (similar to valgrind)
