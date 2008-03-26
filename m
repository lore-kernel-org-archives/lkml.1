Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbYCZSkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbYCZSkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYCZSkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:40:09 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:51851 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbYCZSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ubXWyoGPlOm5IfB8e2GtVMVck54JQlQ4b9g/u7ec0Q4t8IteGAf5dr2UGcmhTYi1Ji6L3ZuxmeDTM7qnesof2znf+xHUj+hexOl9D5mogYi6IlnzfF9jStkkf/QpldFoGBFH7ucipk0cZd+xKaidldzZLHFqkV8/GNYxr4uBPpI=
Message-ID: <8bd0f97a0803261140w7498b0cfwff38302779f589dc@mail.gmail.com>
Date: Wed, 26 Mar 2008 14:40:06 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] [Blackfin try #2] char driver for Blackfin on-chip OTP memory
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       "Wim Van Sebroeck" <wim@iguana.be>, "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <47EA971B.1020502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206580131-22527-1-git-send-email-cooloney@kernel.org>
	 <47EA268F.8070006@gmail.com>
	 <8bd0f97a0803260731x4378c71q1e2e5598c1728e1d@mail.gmail.com>
	 <47EA971B.1020502@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 2:34 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 03/26/2008 03:31 PM, Mike Frysinger wrote:
>  > On Wed, Mar 26, 2008 at 6:33 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>  >> On 03/27/2008 02:08 AM, Bryan Wu wrote:
>  >>  > From: Mike Frysinger <vapier.adi@gmail.com>
>  >>> +static int __init bfin_otp_init(void)
>  >>  > +{
>  >>  > +     int ret;
>  >>  > +
>  >>  > +     stampit();
>  >>  > +
>  >>  > +     ret = misc_register(&bfin_otp_misc_device);
>  >>  > +     if (ret) {
>  >>  > +             pr_init(KERN_ERR PFX "unable to register a misc device\n");
>  >>  > +             return ret;
>  >>  > +     }
>  >>  > +
>  >>  > +     pr_init(KERN_INFO PFX "initialized\n");
>  >>
>  >>  except the fact, that pr_init definition seems to be broken. Its defined __fmt
>  >>  is const, so it should reside in .init.rodata (__initconst), not .init.data
>  >>  (__initdata).
>  >
>  > i dont see an __initconst macro anywhere ?
>
>  It's in include/linux/init.h as of 2.6.25-rc2.

driver was developed against ~2.6.21 and that isnt even in 2.6.24,
that's why the drivers dont currently use it

>  > also, it isnt "broken" in the sense that it "doesnt work" ;)
>
>  Gcc simply doesn't allow that, you likely got 2 sections with init.data, with
>  and without readonly bit set, which is wrong, and it seems, that on some systems
>  (debian) you won't even compile it.

gcc-4.1.2/binutils-2.17 doesnt have a problem compiling/linking the
code in question.  and i imagine i would have noticed a build/link
failure long before testing it on actual hardware.

Bryan can make the changes before pushing for 2.6.25 inclusion ...
otherwise they'll just stay that way until 2.6.25 gets released, and
then i'll do it.
-mike
