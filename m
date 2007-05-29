Return-Path: <linux-kernel-owner+w=401wt.eu-S1765035AbXE2Kwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765035AbXE2Kwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 06:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764850AbXE2KwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 06:52:06 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:54309 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764839AbXE2KwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 06:52:03 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <a781481a0705290341w4c403c1ej43565a1e66805522@mail.gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <292C7F80-B80D-4645-8FF5-49BF911398E1@cam.ac.uk> <a781481a0705290341w4c403c1ej43565a1e66805522@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <37DB6EAF-8954-448D-BD29-864FEC6540CE@cam.ac.uk>
Cc: "Nitin Gupta" <nitingupta910@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: Makefile question (was [RFC] LZO de/compression support - take 6)
Date: Tue, 29 May 2007 11:51:48 +0100
To: "Satyam Sharma" <satyam.sharma@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2007, at 11:41, Satyam Sharma wrote:

> This is syntactically correct (and wouldn't produce any build errors),
> but it's quite ... strange, still. Why would I even want to /build/  
> the
> compress code if all I selected was the decompress option?

Apologies, you gave me the answer I was looking for (make is  
'intelligent' enough not to build the same file twice in this  
situation...) but I think you may have missed the makefile in the  
lzo1x directory:

> diff --git a/lib/lzo1x/Makefile b/lib/lzo1x/Makefile
> new file mode 100644
> index 0000000..7b56a4d
> --- /dev/null
> +++ b/lib/lzo1x/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_LZO1X_COMPRESS) += lzo1x_compress.o
> +obj-$(CONFIG_LZO1X_DECOMPRESS) += lzo1x_decompress.o

Thus, the Kconfig options for compress/decompress won't be simply  
'dummy' options...

Given the shared private header between the compress and decompress  
code, I don't think there is any need to separate the code into two  
directories a la the zlib code.

Sorry for noise,

Michael-Luke
