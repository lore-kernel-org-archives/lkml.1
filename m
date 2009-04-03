Return-Path: <linux-kernel-owner+w=401wt.eu-S1764403AbZDCLsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764403AbZDCLsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762185AbZDCLsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:48:25 -0400
Received: from mail.crca.org.au ([67.207.131.56]:45470 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762012AbZDCLsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:48:24 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Andreas Robinson <andr345@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
In-Reply-To: <1238756060.11839.19.camel@andreas-desktop>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
	 <49D3D4C0.1080506@zytor.com> <1238624827.15230.58.camel@andreas-desktop>
	 <49D3EDEA.4090803@zytor.com>  <49D3F4A3.1040609@linux.intel.com>
	 <1238629202.9027.111.camel@nigel-laptop>
	 <1238675410.13249.42.camel@andreas-desktop>
	 <1238705969.10479.8.camel@nigel-laptop>
	 <1238756060.11839.19.camel@andreas-desktop>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Fri, 03 Apr 2009 22:48:14 +1100
Message-Id: <1238759294.9692.49.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2009-04-03 at 12:54 +0200, Andreas Robinson wrote:
> The LZO compressor can produce more bytes than it consumes but here the
> output buffer is the same size as the input.
> This macro in linux/lzo.h defines how big the buffer needs to be:
> #define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)

Okay. Am I right in thinking (from staring at the code) that the
compression algo just assumes it has an output buffer big enough? (I
don't see it checking out_len, only writing to it). If that's the case,
I guess I need to (ideally) persuade the cryptoapi guys to extend the
api so you can find out how big an output buffer is needed for a
particular compression algorithm - or learn how they've already done
that (though it doesn't look like it to me).

> If there are multiple threads perhaps they clobber each other's output
> buffers?

Nope. The output buffers you see here are fed to the next part of the
pipeline (the block I/O code), which combines them (under a mutex) into
a stream of |index|size|data|index|size|data... so that we don't have to
worry at all about which processor compressed (or decompresses data
later). As I said earlier, it's worked fine with LZF - or no compression
- for years. It's just LZO that causes me problems.

Thanks!

Nigel

