Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbYCZVNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbYCZVNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYCZVMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:12:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:30880 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbYCZVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KTWaJIPbJaFvgijWSOHhmR2/zV4SPEaKScFSQlL8bgkD6funA+jlSr+e6KyZC3lcG8wyCEWv5HTcdX2bp4ipNprRTMdgto1yQDhV2e7H8JIxEWjjL3m3QpISPnn1of3XIKwDqvaoYBVnR2RbZPFDZBUlkXes0P8TPl3DnnycNEY=
Message-ID: <8bd0f97a0803261412t1b6fd2c7nef86d56a49994c3c@mail.gmail.com>
Date: Wed, 26 Mar 2008 17:12:53 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 1/1] [Blackfin try #2] char driver for Blackfin on-chip OTP memory
Cc: "Jiri Slaby" <jirislaby@gmail.com>, "Bryan Wu" <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, "Wim Van Sebroeck" <wim@iguana.be>
In-Reply-To: <20080326210819.GC24954@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206580131-22527-1-git-send-email-cooloney@kernel.org>
	 <47EA268F.8070006@gmail.com>
	 <8bd0f97a0803260731x4378c71q1e2e5598c1728e1d@mail.gmail.com>
	 <47EA971B.1020502@gmail.com>
	 <8bd0f97a0803261140w7498b0cfwff38302779f589dc@mail.gmail.com>
	 <20080326190917.GB24954@uranus.ravnborg.org>
	 <8bd0f97a0803261214y3db259edxbb22b8655a5c6693@mail.gmail.com>
	 <20080326210819.GC24954@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 5:08 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Mar 26, 2008 at 03:14:14PM -0400, Mike Frysinger wrote:
>  > On Wed, Mar 26, 2008 at 3:09 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>  > >  > >  > also, it isnt "broken" in the sense that it "doesnt work" ;)
>  > >  > >
>  > >  > >  Gcc simply doesn't allow that, you likely got 2 sections with init.data, with
>  > >  > >  and without readonly bit set, which is wrong, and it seems, that on some systems
>  > >  > >  (debian) you won't even compile it.
>  > >  >
>  > >  > gcc-4.1.2/binutils-2.17 doesnt have a problem compiling/linking the
>  > >  > code in question.  and i imagine i would have noticed a build/link
>  > >  > failure long before testing it on actual hardware.
>  > >
>  > >  target arch dependent. Try with 64 bit powerpc.
>  >
>  > this code appears in drivers that are for Blackfin-specific pieces of
>  > hardware.  it may fail to build on
>  > some-random-arch-that-isnt-Blackfin, but if it works for Blackfin,
>  > what do the other arches realistically matter ?
>  >
>  > yes, the code will get changed as suggested as it is the right thing
>  > to do, it just isnt a real problem today.
>
>  It is a real problem for build monkeys (like me sometimes) if
>  an allyesconfig suddenly does not build.

it isnt a problem at all considering the next part:

>  If this driver can be build for other than blackfin I do not
>  know.

it's a device driver for hardware on the Blackfin processor itself.
the Kconfig has "depends on BLACKFIN".  it just aint gonna be an issue
:).
-mike
