Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175Ab0AGFnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0AGFnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633Ab0AGFnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:43:24 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41966 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0AGFnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:43:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IPpwhHkLiL9C1ZiQu5uYHnCzmXo+eQYuEGe0I8K3brBhPToTr8BTeR1WYX5AFkxL/t
         18zI3D5sSQYXauHjxVM3GxgC7ycR38K+p7ogNCclZG4f1CaRVAg08G3O1FHqq7ISF39c
         4im6Hy+yp4oS9U7u666kNEWDUcd65PwUMn9MU=
MIME-Version: 1.0
In-Reply-To: <4B448EE3.5060200@linux.intel.com>
References: <daef60381001060123vbb09aecy7943d72fcb8278a@mail.gmail.com> 
	<4B448EE3.5060200@linux.intel.com>
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 7 Jan 2010 13:43:03 +0800
Message-ID: <daef60381001062143i67da4203rb02919b64794664c@mail.gmail.com>
Subject: Re: [PATCH] Fix markup_oops.pl get error in x86
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-1?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 21:23, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 1/6/2010 1:23, Hui Zhu wrote:
>>
>>        }
>> $func_offset will get a number like "0x2"
>> But in follow code:
>> my $decodestart = Math::BigInt->from_hex("0x$target") -
>> Math::BigInt->from_hex("0x$func_offset");
>> It add other ox to ox2.
>> Then this value will be set to NaN.
>>
>> So I make a small patch to fix it.
>
>> -       if ($line =~ /EIP is at
>> ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
>> +       if ($line =~ /EIP is at
>> ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/[a-f0-9]/) {
>
> I think this makes sense, but would you not also need to add "x" to the list
> of allowed characters?
> so   [a-f0-9x]
> ?
>
>

Ah, sorry I make a mistake.  I think the last 0x need be keep.

What about this version?

Thanks,
Hui

---
 scripts/markup_oops.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -154,7 +154,7 @@ while (<STDIN>) {
 	if ($line =~ /RIP: 0010:\[\<([a-z0-9]+)\>\]/) {
 		$target = $1;
 	}
-	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
+	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/0x[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}
