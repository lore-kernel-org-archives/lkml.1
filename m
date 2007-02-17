Return-Path: <linux-kernel-owner+w=401wt.eu-S1750818AbXBQUBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818AbXBQUBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 15:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbXBQUBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 15:01:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:3062 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbXBQUBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 15:01:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=luzu4mXYnwgf7A6Mp9+pwi4tFPNkDdljd6rsen6tiKBOFqdPwnTSTAemP/1LWGMKHaK5/350BGpRcq02HGEXvzYeYFHiP18nSc8VaumQTiv5nhU1OUn49M8ZtXTh3tfm7+0Nov05a/TL3xOO3/bD98WTCJ0hKGBrPE7ZAhFuD34=
Message-ID: <f56c1ba00702171201y1e4ea025t510e4d4e7dbcf3b2@mail.gmail.com>
Date: Sat, 17 Feb 2007 21:01:32 +0100
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: 2.6.20-mm1 - Oops using Minix 3 file system
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Aragones" <danarag@gmail.com>, linux-kernel@vger.kernel.org,
       Cedric.augonnet@ens-lyon.org
In-Reply-To: <45D75A1F.8060504@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f56c1ba00702161500x775fe04bl91889b5819cf9ddc@mail.gmail.com>
	 <45D75A1F.8060504@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/17, Bill Davidsen <davidsen@tmr.com>:
> Cédric Augonnet wrote:
> >
> > Hi Daniel,
> >
> > On 2.6.20-rc6-mm3 and 2.6.20-mm1, i get an OOPS when using the minix 3
> > file system. I enclose the dmesg and the .config to that mail.
> >
> > Here are the steps to reproduce this oops (they involve using qemu to
> > run Minix 3)
> > - First create a 2GB image using
> >      qemu-img create minix.img 2G
> >   (Please note that this seem to be producing an eroneous image)
> > - Then launch Minix inside qemu to make a minix partition on this
> > image using mkfs on the corresponding device.
>
> That's two steps, right? First you make a partition on the "disk" qemu
> provides, then you put a filesystem on the partition? Or did you put a
> filesystem on the raw device?
>

Yes, i first create a RAW image of a disk. Then, i use this image file
as an image given to qemu. Inside qemu, running Minix i issue mkfs
/dev/c0d1 (this is corresponding to this image).


> > - Mount the image on loopback using
> >  mount -t minix -o loop minix.img /mnt/qemu/
>
> Does mount know to use Minux3 with this command line?
>

Well at least it is yet allowing to do so. And most things work like hell.

> > - issue a "df" command on /mnt/qemu
> >
> > This oops occurs everytime i use df on this directory. However, this
> > does not occur if the image was for a 1MB partition. And it does not
> > occur if the partition on which we created minix.img was the same as
> > the partition on which qemu stands. Sounds like qemu has an issue and
> > creates an erroneous partition which linux does not handle correctly.
> >
> > Regards, and thanks for your patch by the way !
>
> Having been burned a few times by the fact that qemu provides disk
> images which then (normally) get partitions, I'm not sure you aren't
> having the same problem.
>
> None of which justifies the OOPS, of course, nice kernels don't go down.
>

That is my all point actually, i am not telling i have a valid
partition. I'm just describing the fact that the minix fs driver is
making too many assumptions on the partition it is given. For sure
there must be something nasty about this image, as you told this is
the duty of the kernel not to mount such a partition if it is not a
partition. Here I was only giving an example of the way we could trick
the driver. This is as important as having the driver working
correctly on valid partitions i suppose.

> --
> Bill Davidsen <davidsen@tmr.com>
>    "We have more to fear from the bungling of the incompetent than from
> the machinations of the wicked."  - from Slashdot
>

Regards,
Cédric
