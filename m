Return-Path: <linux-kernel-owner+w=401wt.eu-S1751170AbXBMHtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbXBMHtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXBMHtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:49:05 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:54942 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbXBMHtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:49:03 -0500
Date: Tue, 13 Feb 2007 16:48:57 +0900 (JST)
Message-Id: <20070213.164857.33144817.yoshfuji@linux-ipv6.org>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)"
 to "array_for_each(index, array)"
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <1171324070.1528.25.camel@localhost>
References: <1171324070.1528.25.camel@localhost>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <1171324070.1528.25.camel@localhost> (at Mon, 12 Feb 2007 15:47:50 -0800), Joe Perches <joe@perches.com> says:

> Now that most of the sizeof(array)/sizeof(array[0])
> conversions have been done (there are about 800 done
> and about another 130 left), perhaps it could be
> useful to change the code to use a define similar
> to the list_for_each
> 
> #define list_for_each(pos, head) \
> 	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
>         	pos = pos->next)
> 
> perhaps
> 
> #define array_for_each(index, array) \
> 	for ((index) = 0; (index) < ARRAY_SIZE((array)); (index)++)

I dislike this; it is overkill.

list_for_each etc. are for list_head etc., of structures.
On the other hand, arrays are not.

It is very, very obvious how to access its members.

--yoshfuji
