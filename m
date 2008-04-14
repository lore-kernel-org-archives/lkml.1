Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbYDNVhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbYDNVhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYDNVgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:36:52 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:39358 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbYDNVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S/SuA4VdnQmYwizcwFpPrlj+5U87mb7PytG3O8qhwdy4E2Foyxy3ZM9krlgOR9E6VQPbroKpNiXsi0cOv8YlgrG11m+OAaPFfCk+oOaUEc9fS30Bu8+DAkTP5OVAFM1NUhZGiQeGNMZmmterr3/njiLqFit4DtBgZlF0ZNIbkhA=
Message-ID: <86802c440804141436l1b9a2d64h31def99feb4c9302@mail.gmail.com>
Date: Mon, 14 Apr 2008 14:36:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: x86 git tree broken (bisected)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <200804142309.29586.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102159.14563.rjw@sisk.pl> <200804142221.19606.rjw@sisk.pl>
	 <86802c440804141406u7543dbacifb4b93b7b0ee2cc3@mail.gmail.com>
	 <200804142309.29586.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 2:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> On Monday, 14 of April 2008, Yinghai Lu wrote:
>  > On Mon, Apr 14, 2008 at 1:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >
>  > > On Monday, 14 of April 2008, Yinghai Lu wrote:
>  > >  > On Sun, Apr 13, 2008 at 5:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >  > >
>  > >  > > On Monday, 14 of April 2008, Yinghai Lu wrote:
>  > >  > >  > On Sun, Apr 13, 2008 at 3:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >  > >  > >
>  > >  > >  > > On Monday, 14 of April 2008, Yinghai Lu wrote:
>  > >  > >  > >  > On Sun, Apr 13, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >  > >  > >  > ...
>  > >  > >  > >  > >  > can you try to apply the patch i sent to you about agp bridge order
>  > >  > >  > >  > >  > reading for buggy silicon?
>  > >  > >  > >  > >  >
>  > >  > >  > >  > >  > Please boot kernel with "debug"...
>  > >  > >  > >  > >  >
>  > >  > >  > >  > >  > I want to verify if you can get
>  > >  > >  > >  > >  >
>  > >  > >  > >  > >  > "
>  > >  > >  > >  > >  > Aperture conflicts with PCI mapping.
>  > >  > >  > >  > >  > "
>  > >  > >  > >  > >  >
>  > >  > >  > >  > >  > in your boot log...
>  > >  > >  > >  > >
>  > >  > >  > >  > >  It's not present in there:
>  > >  > >  > >  > >
>  > >  > >  > >  > >  rafael@albercik:~> grep Aperture failing-with-patch-dmesg.log
>  > >  > >  > >  > >  Aperture too small (32 MB)
>  > >  > >  > >  > >  Aperture from AGP @ de000000 size 4096 MB (APSIZE 0)
>  > >  > >  > >  > >  Aperture too small (0 MB)
>  > >  > >  > >  > >  agpgart: Aperture pointing to RAM
>  > >  > >  > >  > >  agpgart: Aperture from AGP @ de000000 size 4096 MB
>  > >  > >  > >  > >  agpgart: Aperture too small (0 MB)
>  > >  > >  > >  > >
>  > >  > >  > >  > >  Full dmesg output attached.
>  > >  > >  > >  >
>  > >  > >  > >  > please check attached debug patch. and check if you can change GART
>  > >  > >  > >  > size in your BIOS setup to 64M instead of 32M
>  > >  > >  > >
>  > >  > >  > >  Hm, what tree am I supposed to apply it too:
>  > >  > >  > >  (1) current x86 git
>  > >  > >  > >  (2) current x86 git w/ some of your previous patches (which ones in this case)
>  > >  > >  > >  (3) failing (old) x86 git
>  > >  > >  > >  (4) failing (old) x86 git w/ some of your previous patches (which ones in this
>  > >  > >  > >     case)?
>  > >  > >  >
>  > >  > >  > (1) current x86.git
>  > >  > >
>  > >  > >  Attached is dmesg output from current x86.git with debug_gart_checking.patch
>  > >  > >  applied.
>  > >  >
>  > >  > please test the final one ... ...
>  > >  >
>  > >  > You should get back 64M memory back.
>  > >
>  > >  Tested (current x86.git), dmesg output attached.
>  >
>  > thanks.
>  >
>  > looks good. as expected...
>  >
>  > Checking aperture...
>  > AGP bridge at 00:04:00
>  > Aperture from AGP @ de000000 old size 32 MB
>  > Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
>  > Aperture from AGP @ de000000 size 32 MB (APSIZE 0)
>  > Node 0: aperture @ de000000 size 32 MB
>  > Aperture too small (32 MB) than (64 MB)
>  > ...
>  > agpgart: Detected AGP bridge 20
>  > Setting up ULi AGP.
>  > agpgart: AGP aperture is 32M @ 0xde000000
>
>  BTW, what exactly would be the benefit of increasing the aperture size, given
>  that I use a PCI Express graphics adapter?
you don't need increase that before you are have less 4G RAM.

if you have more than 4G RAM, you may need to increase that to GART
for iommu. so other devices that support only dma32 could use extra
32M.

YH
