Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbXEYFKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbXEYFKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbXEYFKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:10:47 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:50087 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbXEYFKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IWbSD1pXKz7uTeO6S1YOyMLk4FL5ySJuS8EVLLSzm1J5+j8t5PyBpyjnqfPNTE76JVa+HIUNXmCCbO+4+QNZzsDg3wX9INe+Q/AOytbg8bSNjGoshlefXTUwB9QRWHCE3oEgDkk2ZU0+ZsOcbxhyy/s/hwniSeE9XOjR32bz8qM=
Message-ID: <4cefeab80705242210k1169d85k97ce803de02dbc2a@mail.gmail.com>
Date: Fri, 25 May 2007 10:40:41 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Bret Towe" <magnade@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org, "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <dda83e780705241938h2dadeeb9p61c9294ddfd96990@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <dda83e780705230750j43c9e89eh766fdaafb1d671f3@mail.gmail.com>
	 <4cefeab80705240648k2f3c22ddw13374c9d6b2f521a@mail.gmail.com>
	 <dda83e780705241938h2dadeeb9p61c9294ddfd96990@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Bret Towe <magnade@gmail.com> wrote:
> On 5/24/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> > On 5/23/07, Bret Towe <magnade@gmail.com> wrote:
> > > On 5/23/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> >
> > > > For now, tested on x86 only.
> > >
> > > If you have a program to test this I can run it on an amd64 and a g4 ppc
> > >
> >
> > Attached is the kernel module (compress-test) to test this LZO code.
> > Just compile this module against 2.6.22-rc2 with this LZO patch. Then
> > testing can be done as:
> > 1- Mount DebugFS somewhere e.g:
> > mkdir /debug; mount -t debugfs debugfs /debug
> > 2- Load the module and do:
> > cat /path/to/some_file > /debug/compress_test/compress
> > (/var/log/messages should show that compression was successful)
> > 3- Then decompress this file as:
> > cat /debug/compress_test/decompress > /tmp/t
> > (/var/log/messages should show that decompression was successful)
> > 4- For extra verification do:
> > diff /tmp/t /path/to/some_file   -- O/P must be empty
> >
> >
>
> the test worked fine on amd64
> from dmesg:
> LZO compress successful: orig_size=17448, comp_size=8183
> LZO decompress successful: decomp_size=17448
>
> and input and output files I gave it:
> sha1sum test-input output
> 2221c586e3eb869af7f4333d4f56b441b9aa8414  test-input
> 2221c586e3eb869af7f4333d4f56b441b9aa8414  output
>

Good to know it worked correctly on 64-bit system too. I will also
add exporting benchmarking figures soon.

> (will be giving the ppc box the same file to test btw when I get to it)
>
> and I don't know if it matters much but I tried feeding it a 260k file
> and it didn't like it
>
> cat /usr/bin/yelp > /debug/compress_test/compress
> cat: write error: No space left on device
>

Ah! I forgot to mention that max file size to feed is 256K (this was
just for simplicity of compress-test module implementation).

Thanks for your testing.

- Nitin
