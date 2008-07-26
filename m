Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYGZT1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYGZT1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 15:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYGZT1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 15:27:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:24983 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078AbYGZT1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 15:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=J8Gp2OIVbufLXfMvz+BbV5rf0J0Yw1DzKhrfkkPtbiJ1BbSPZ53gPyVTu2XflKKw4/
         h9WbOIJxcmJg1f3fiVn2VR9FgbTaIeK/Hiec+0zGicmTgXoyW4sLYnaN5SpKZl66yVc4
         S3p3L3gvzvzkqNDwIEHFEebn8hKdA7GjW6NhI=
Message-ID: <ea8d860a0807261227w66e29978uecd12cf1fcb915d1@mail.gmail.com>
Date: Sat, 26 Jul 2008 20:27:33 +0100
From: "Marcin Obara" <marcin_obara@users.sourceforge.net>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] 2.6.26-mmotm tpm-correct-tpm-timeouts-to-jiffies-conversion-d820-fix.patch
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Marcel Selhorst" <tpm@selhorst.net>,
       "Kylene Jo Hall" <kjhall@us.ibm.com>, tpmdd-devel@lists.sourceforge.net
In-Reply-To: <15114.1217045033@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725164614.044a526e.akpm@linux-foundation.org>
	 <50684.1217035060@turing-police.cc.vt.edu>
	 <20080725185115.5d1a107d.akpm@linux-foundation.org>
	 <15114.1217045033@turing-police.cc.vt.edu>
X-Google-Sender-Auth: 68f5846d48a92320
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/26  <Valdis.Kletnieks@vt.edu>:
> +       if (chip->vendor.duration[TPM_SHORT] == 1)
> +               chip->vendor.duration[TPM_SHORT] *= 1000;
> +
>        chip->vendor.duration[TPM_MEDIUM] =
>            usecs_to_jiffies(be32_to_cpu
>                             (*((__be32 *) (data +


Value in  chip->vendor.duration[TPM_SHORT]  is in jiffies not in  milliseconds.
 (As I know it's not the same. Jiffy is in range 1-10 ms.)
I know the result may be the same, but it is unclear.

Maybe... value should be compared (to 1000) before conversion?
or...
If after conversion, there should be something like this:
       if (chip->vendor.duration[TPM_SHORT]  < (HZ/100))  /*  less
than 10ms ? */
               chip->vendor.duration[TPM_SHORT] = HZ;

What do you think?

Regards
Marcin
