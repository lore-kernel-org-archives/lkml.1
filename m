Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbYCGSSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbYCGSSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbYCGSSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:18:42 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:4000 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbYCGSSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:18:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EC1Lkw04YfuECvMb6aW20qW9sAel6jFnASdFKQ1Mt6PK3iAVX1wZncR09DkjIiRFgpkSPS3TzyCMJUD9gOKEKF+NAtvYAd7qR20vvQJ2TWj5/QAZkgFSplGwgR820hYCkzNXp+TXmCkygOYvIYVJC4YRAd9C/xqp++/v+GtZrlY=
Message-ID: <12c511ca0803071018v2f16522alf6817282fffc2a39@mail.gmail.com>
Date: Fri, 7 Mar 2008 10:18:40 -0800
From: "Tony Luck" <tony.luck@intel.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
Cc: "Milan Broz" <mbroz@redhat.com>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       "Alasdair G Kergon" <agk@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
In-Reply-To: <20080222123423.GA12678@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com>
	 <47BC0DA9.1030607@redhat.com>
	 <20080220172449.GD27726@gondor.apana.org.au>
	 <47BC67CE.9070407@redhat.com>
	 <20080220175819.GA28246@gondor.apana.org.au>
	 <20080222123423.GA12678@gondor.apana.org.au>
X-Google-Sender-Auth: c53b4cbb10749501
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 4:34 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
>  Does this patch fix the problem?
...
>  diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
>  index 2ba42cd..a8f1264 100644
>  --- a/include/crypto/internal/skcipher.h
>  +++ b/include/crypto/internal/skcipher.h
...
>  +int __init eseqiv_module_init(void);
>  +void __exit eseqiv_module_exit(void);
>  +int __init chainiv_module_init(void);
>  +void __exit chainiv_module_exit(void);

The zx1_defconfig in ia64 tree has CONFIG_CRYPTO_BLK_CONFIG=y ... making
these symbols not only causes build warnings:
chainiv_module_exit' referenced in section `.init.text' of
crypto/built-in.o: defined in discarded section `.exit.text'
eseqiv_module_exit' referenced in section `__ksymtab_gpl' of
crypto/built-in.o: defined in discarded section `.exit.text'

it also manages to make my "ld" dump core!

-Tony
