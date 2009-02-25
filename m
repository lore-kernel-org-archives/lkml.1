Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbZBYWfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbZBYWfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZBYWfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:35:34 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:61410 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZBYWfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:35:34 -0500
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 17:35:33 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KRoagR1OkZNATPGYMbR5MWxJoICy4FlfYz4xHerHUQpECv48LnNVIn7KDpvHD5LoH3
         0PX+VpzRmn6opRAHRazk+pOy7cxWy7st3965Kx5o6McqCTBVDzUBHah60Zg+IJFCrut8
         8D/BiOpvd3r5Vh+Ifan/eN/Tg8OxL9mfjEZ3o=
MIME-Version: 1.0
In-Reply-To: <20090225.140136.74121676.davem@davemloft.net>
References: <49A549EE.7020202@gmail.com> <20090225170901.GA26634@coraid.com>
	 <20090225.140136.74121676.davem@davemloft.net>
Date: Wed, 25 Feb 2009 23:29:13 +0100
Message-ID: <25e057c00902251429x296a5bfcjfd3d90b7989017f1@mail.gmail.com>
Subject: Re: [PATCH] aoe: error printed 1 too early
From: roel kluin <roel.kluin@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/25 David Miller <davem@davemloft.net>:
> From: Ed Cashin <ecashin@coraid.com>
> Date: Wed, 25 Feb 2009 12:09:02 -0500
>
>> Sounds like a good catch.  Did you find it because you saw the "cannot
>> free skb" message?
>
> He's finding these by looking for them in the code, not by
> actually triggering the condition.
>

Actually I made all functions a single line and then run some
bash scripts that parses pseudocode like:

echo "INFO: \7 reaches \9 - 1 after loop"
bli "	
	if \((${npz}[&|][&|])?
		--($w) $em?[<=] ($K|$w|$d)
		((&&|\|\|)$(nestedcode "()"))?\)
	(\{
		($(nestedcode "{}"))*
		break ;
	\}|
		break ;
	)
	$ccode
	(
		$Q(\7 [=$em]= \9|\7 (>=|<) \9)
	|
		return \7 ;
	)
	"

This gives me a match like:
  while(...) {
    if (--i < 0)
      break;
    ...
  }
  ...
  if (i != 0)
    ...
which is wrong since i reaches -1.
