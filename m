Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbXE3NGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbXE3NGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbXE3NGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:06:00 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50294 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751655AbXE3NF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:05:59 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Mark Adler <madler@alumni.caltech.edu>
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Date: Wed, 30 May 2007 09:05:51 -0400
User-Agent: KMail/1.9.6
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       jloup@gzip.org
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com> <172CB60C-2F1F-4CCE-8AB7-C7CFA1161AA0@alumni.caltech.edu>
In-Reply-To: <172CB60C-2F1F-4CCE-8AB7-C7CFA1161AA0@alumni.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705300905.51887.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2007 01:31:19 Mark Adler wrote:
> On May 29, 2007, at 8:15 AM, Satyam Sharma wrote:
> > skipping some checksum calculation if some
> > flag (PRESET_DICT) is absent from the input stream about to
> > be decompressed ...
>
> You don't need to dissect the header manually to look for that bit.
> If you feed inflate() at least the first two bytes, it will return
> immediately with the Z_NEED_DICT return code if a preset dictionary
> is requested.  You can force inflate() to return immediately after
> decoding the two byte header even if a preset dictionary is not
> requested by using the Z_BLOCK flush code.
>
> Mark

I think that JFFS2 is doing the work of looking for PRESET_DICT itself not 
only to skip the checksum calc, but also to lose the function-call overhead. 
Yes, the performance difference shouldn't be all that great, but might have 
made a difference in some test. When I'm done working on the 
benchmark/testbed for the LZO code proposed for inclusion in the kernel I'll 
do some testing and see how large the difference is in userspace. (for most 
code the differences hold true, though usually with less drastic numbers, in 
kernel)

DRH
