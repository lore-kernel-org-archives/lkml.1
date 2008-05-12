Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYELOi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYELOi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 10:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbYELOiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 10:38:00 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:24171 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbYELOh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 10:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ndf2xKsr2vGHzikHpGUO/Y5XqesBKDbNdR07yOi5uLt/RgGA1hxaAan1fbxSFJcAJ78Ie/nvStN4tLTe/Sxu7gM8zahqyZ29jNf0KyuXFgu8jBgDcmLbCRPLGU7fcwu0rEAQ7GHpFMYvILkWZwRmT0gIO8XRR5jj8VE6mg0+/yw=
Message-ID: <386072610805120737y7a243d99o5a855564575d2fb8@mail.gmail.com>
Date: Mon, 12 May 2008 22:37:53 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH try#2] [MTD/MAPS] Blackfin BF5xx Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Cc: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>,
       "Bryan Wu" <bryan.wu@analog.com>, dwmw2@infradead.org,
       will.newton@gmail.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0805120548k356aff52pdf66acf88fadfebb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1202020355.6671.23.camel@roc-laptop>
	 <20080512122650.GA10014@logfs.org>
	 <8bd0f97a0805120548k356aff52pdf66acf88fadfebb@mail.gmail.com>
X-Google-Sender-Auth: 874ef58e81c9f6c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 8:48 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, May 12, 2008 at 8:26 AM, Jörn Engel <joern@logfs.org> wrote:
>  > On Sun, 3 February 2008 14:32:35 +0800, Bryan Wu wrote:
>  >> +static void bf5xx_copy_from(struct map_info *map, void *to,
>  unsigned long from, ssize_t len)
>  >> +{
>  >> +     unsigned long i;
>  >> +     map_word test;
>  >> +
>  >> +     if ((unsigned long)to & 0x1) {
>  >> +             for (i = 0; i < len / 2 * 2; i += 2) {
>  >> +                     test = bf5xx_read(map, from + i);
>  >> +                     put_unaligned(test.x[0], (__le16 *)(to + i));
>  >> +             }
>  >> +     } else {
>  >> +             for (i = 0; i < len / 2 * 2; i += 2) {
>  >> +                     test = bf5xx_read(map, from + i);
>  >> +                     *((u16*)(to + i)) = test.x[0];
>  >                        ^^^^^^^^^^^^^^^^^
>  >
>  > I'm not particularly fond of such constructs, maybe because I have such
>  > a hard time understanding what the code actually does.
>  >
>  > How about:
>  >        u16 *foo = to;
>  >
>  >        for (i = 0; i < (len & ~1); i++) {
>  >                test = bf5xx_read(map, from + 2 * i);
>  >                foo[i] = test.x[0];
>  >        }
>  >
>  > With perhaps a better name than "foo" and the same conversion in the
>  > rest of the function as well?
>
>  indeed.  Bryan: i can take care of this as there's a few other pieces
>  i want to fiddle first (like getting rid of "bf5xx")
>  -mike
>

My pleasure. Thanks.
This patch has been in my queue for a long time

-Bryan
