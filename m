Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0BYQRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:17:07 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51233 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab0BYQRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:17:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pFbmgbTVZ7hH0dJBdprMux4GqHVghQH7exuwXMD/iLWs3vsnkhw0lNQ9TMapUcfjia
         EdIwAYo5wNCYqbPkVRhmP0Hjtn5+uASMlEdLVlLaYdGCVJ+VUQMSIDGCBzY6+v9W+sxD
         BUCtgM3MqxqNuRtO0LgGDhbpyydwvapGTXXUY=
MIME-Version: 1.0
In-Reply-To: <19334.40337.651079.440912@pilspetsen.it.uu.se>
References: <4B8692E3.9030509@gmail.com>
	 <19334.40337.651079.440912@pilspetsen.it.uu.se>
Date: Thu, 25 Feb 2010 18:16:59 +0200
X-Google-Sender-Auth: 9cbee3a0ee9930f6
Message-ID: <84144f021002250816o2c2cef0fke484c7e43256dba4@mail.gmail.com>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in 
	sha1_update()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Roel Kluin <roel.kluin@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 5:56 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> I fear that the only portable (across compiler versions) and safe
> solution is to invoke an assembly-coded dummy function with prototype
>
>        void use(void *p);
>
> and rewrite the code above as
>
>        {
>                u32 temp[...];
>                ...
>                memset(temp, 0, sizeof temp);
>                use(temp);
>        }
>
> This forces the compiler to consider the buffer live after the
> memset, so the memset cannot be eliminated.

So is there some "do not optimize" GCC magic that we could use for a
memzero_secret() helper function?

                        Pekka
