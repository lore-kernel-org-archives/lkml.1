Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZCCNRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZCCNRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZCCNRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:17:33 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:62373 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZCCNRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GlTEhedeWi+AUcXe7rUZ1hIsToWHPJY97DQ+PE/S1C3usUpzzGt9+XBVE6fCklREA1
         8KeJIBL5IsoKnBN11M08kqmw+FTOHBaKQcqPnxtTEhexAU2/nMFoqZIWIIiB7DRZhZy5
         nTUSpU10AsSGN1yTbPO36ykI/yoj6alLwKLIE=
MIME-Version: 1.0
In-Reply-To: <87a5b0800903030133y7bd22204y4995657cfd75950f@mail.gmail.com>
References: <1236007103.18284.83.camel@penberg-laptop>
	 <82ecf08e0903020750q3670de6u4162e4f01c847003@mail.gmail.com>
	 <1236014911.18284.89.camel@penberg-laptop>
	 <82ecf08e0903020942i55e1a31bn983c2ce243e342e9@mail.gmail.com>
	 <87a5b0800903030133y7bd22204y4995657cfd75950f@mail.gmail.com>
Date: Tue, 3 Mar 2009 10:17:30 -0300
Message-ID: <82ecf08e0903030517r49367e42ybf21e0020f35f6ce@mail.gmail.com>
Subject: Re: [PATCH] crc32: remove useless __pure modifier from functions
From: Thiago Galesi <thiagogalesi@gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Did you see any change in size of your kernel with this annotation? It
> didn't seem to have any effect as far as I could tell.

No, because I didn't test it with the kernel. Anyway, probably size
won't change a lot.

What the compiler does is: if (you're saying) it's a pure function,
and it has been called previously with the same parameters, the return
value is identical, hence, the compiler doesn't need to call the
function again.

Here's the test I did http://duskblue.org/pure_test.tar.gz Pretty
straighforward, but you have to 'make CFLAGS=-O1' to make the
optimization work.

>
> There are a number of functions in lib/ code that could be marked
> __pure or __attribute_const__ but I'm not sure if it's worth the
> effort, for my compiler (gcc 4.2) at least.
>

What const does is similar: it indicates that the function will not
change parameters marked with __const, so it will not need to reload
them after the function is called.

-- 
-
Thiago Galesi
