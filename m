Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbYGFU3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbYGFU3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbYGFU3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:29:43 -0400
Received: from ag-out-0708.google.com ([72.14.246.243]:51712 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbYGFU3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FYGOc104ZH6NZUwffTzkP1pj+rHQ0b93NeFM62xIyz64pEln7GQggBNJCupbrAlBJS
         uYKI0uO5bVB/jl5PgL6JOn1Sl89s+qQE3YRkNczOj5PcwD85F2r/gqsw38vIdQKXhDrE
         TrQLu9keWWSBLoXUkWKblsbh/OAGqH/xZzlGQ=
Message-ID: <a4423d670807061329m6b9dfd69if2e48aa7b3be599b@mail.gmail.com>
Date: Mon, 7 Jul 2008 00:29:36 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] x86 setup.c: cleanup includes
Cc: mingo@elte.hu, yhlu.kernel@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080706105840.90ac5219.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807060913red9187bj7bcc886d1fb20ad3@mail.gmail.com>
	 <20080706105840.90ac5219.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/6 Randy Dunlap <randy.dunlap@oracle.com>:
> Did you do these manually (by personal inspection) or by some tool?
> If a tool, what tool/where is it?  Thanks.

It is a simple script like this:

find . -name "*.h" -exec grep.sh {} \;
find . -name "*.c" -exec grep.sh {} \;

grep.sh:
#!/bin/sh
grep -H "^#include" $1|sed "s,/\*.\+,,"|grep -v ":$"|sort|uniq -c|grep
-v "^ \+1:"

I have found about 70-80 double inclusions, but most of them have
reason for that and can not be removed.
