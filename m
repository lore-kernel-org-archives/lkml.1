Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbXEZLRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbXEZLRi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 07:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXEZLRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 07:17:32 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:37216 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbXEZLRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 07:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=In8lvshl28gir2o5T2sLjU3KMF2/0osXNklPQpb+KR12wC0b6mYEE0YaMVdiviNzazx2Fq44tlaV+TSogJ4hRA8bHDwPtoQ9QEfH02L76vFl+OYBS0O3rTUqrxHJeROYocJ3u8uLHaICX8GkzmSeM9gJkhhkzsaQdp5/7spMHvQ=
Message-ID: <4cefeab80705260417h43d4d8a9s3f55b7eb3c19396c@mail.gmail.com>
Date: Sat, 26 May 2007 16:47:30 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: "Richard Purdie" <richard@openedhand.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
In-Reply-To: <20070525104253.GA4555@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
	 <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk>
	 <4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com>
	 <1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk>
	 <4cefeab80705230721i492b5f1ehfa2d775344b1c04e@mail.gmail.com>
	 <20070523091601.f8c6b833.akpm@linux-foundation.org>
	 <1179938960.5864.26.camel@localhost.localdomain>
	 <4cefeab80705232104n54b23b9bi8b5db8e6a6dd1c0a@mail.gmail.com>
	 <20070525104253.GA4555@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Just did some benchmarking; results below.

On 5/25/07, Pavel Machek <pavel@ucw.cz> wrote:
>
> What is the performance difference between safe and unsafe version?
>

File size: 256K
- Following as tests for original test code - not any kernel port of this.
- Test with each block size repeated 5 times - taken avg. of these 5 runs.
- Same file used for each test.
- Used lzotest utility (included with LZO 2.02) for testing.

Blocksize	Comp*		DU*		DS*		Speed%
4		59.356		211.526		195.260		7.689
8		54.623		202.712		188.369		7.075
16		50.342		196.482		183.988		6.358
32		47.499		189.800		177.455		6.504
64		44.148		178.724		167.201		6.447
128		42.125		170.229		159.257		6.445
256		41.830		155.035		146.115		5.753

* All speeds in MB/sec
Comp = LZO1X-1
DU = Decompress (unsafe)
DS = Decompress (safe)
Speed% = ((DU-DS)/DU)*100

I have yet to see how the kernel ports compare against this original version.

Cheers,
Nitin
