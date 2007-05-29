Return-Path: <linux-kernel-owner+w=401wt.eu-S1764928AbXE2L2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764928AbXE2L2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbXE2L2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:28:01 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:46330 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbXE2L17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WvN023JZLqE3KaWhQ9iZtvSoGS9nEGNFOCvWoHRtNsXL0kBqhcLNNSzwXNZWfG4DUVlWTF4E386lxUsC1Mxh6sa3/wEijm9T61REnL+1j+J3KiX+WHcfSNY+UdfEtY5XjtNbB8jS76n2i2DysvIEOFlJm9lMyiTFGpSImKsEbgY=
Message-ID: <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com>
Date: Tue, 29 May 2007 16:57:57 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Michael-Luke Jones" <mlj28@cam.ac.uk>
Subject: Re: Makefile question (was [RFC] LZO de/compression support - take 6)
Cc: "Nitin Gupta" <nitingupta910@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>
In-Reply-To: <37DB6EAF-8954-448D-BD29-864FEC6540CE@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <292C7F80-B80D-4645-8FF5-49BF911398E1@cam.ac.uk>
	 <a781481a0705290341w4c403c1ej43565a1e66805522@mail.gmail.com>
	 <37DB6EAF-8954-448D-BD29-864FEC6540CE@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
> On 29 May 2007, at 11:41, Satyam Sharma wrote:
>
> > This is syntactically correct (and wouldn't produce any build errors),
> > but it's quite ... strange, still. Why would I even want to /build/
> > the
> > compress code if all I selected was the decompress option?
>
> Apologies, you gave me the answer I was looking for (make is
> 'intelligent' enough not to build the same file twice in this
> situation...) but I think you may have missed the makefile in the
> lzo1x directory:
>
> > diff --git a/lib/lzo1x/Makefile b/lib/lzo1x/Makefile
> > new file mode 100644
> > index 0000000..7b56a4d
> > --- /dev/null
> > +++ b/lib/lzo1x/Makefile
> > @@ -0,0 +1,2 @@
> > +obj-$(CONFIG_LZO1X_COMPRESS) += lzo1x_compress.o
> > +obj-$(CONFIG_LZO1X_DECOMPRESS) += lzo1x_decompress.o

Ah, yes, I only saw the mail and didn't check lib/lzo1x/Makefile, thanks.
So effectively, we've done precisely what zlib does too ... only, in a
smarter way!

> Thus, the Kconfig options for compress/decompress won't be simply
> 'dummy' options...
>
> Given the shared private header between the compress and decompress
> code, I don't think there is any need to separate the code into two
> directories a la the zlib code.

Right, actually, zlib could be switched over to this style, in fact.
Because zlib_deflate/ and zlib_inflate/ too share a private header
zutil.h which has unfortunately been stuck into include/linux/ with a big
/* WARNING: this file should *not* be used by applications. */ comment ...

Satyam
