Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbXFPPId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbXFPPId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 11:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbXFPPIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 11:08:25 -0400
Received: from pat.uio.no ([129.240.10.15]:58546 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbXFPPIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 11:08:24 -0400
Subject: Re: 2.6.21.14 NFS related oops
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Maciej =?UTF-8?Q?So=C5=82tysiak?= <solt2@dns.toxicfilms.tv>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <93879EA4546642A48E9511F1AD29E031@pysiak>
References: <466FDC76.6020207@dns.toxicfilms.tv>
	 <1181762227.6151.55.camel@heimdal.trondhjem.org>
	 <93879EA4546642A48E9511F1AD29E031@pysiak>
Content-Type: text/plain; charset=utf-8
Date: Sat, 16 Jun 2007 11:08:19 -0400
Message-Id: <1182006499.26143.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.088)
X-UiO-Scanned: 2EB9370E511EB528FF1B83DD6C50ACF270A63BFC
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 35 total 2406191 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-16 at 11:26 +0200, Maciej Sołtysiak wrote:
> >>  =======================
> >> Code: 10 89 5c 24 10 89 c3 89 7c 24 18 89 d7 89 74 24 14 8b 70 28 75 1a 
> >> 8b
> >> 4e 08 89 fa 89 d8 ff 51 18 8b 5c 24 10 83 74 24 14 8b 7c 24 <18> 83 c4 1c 
> >> c3
> >> 89 74 24 0c 8b 40 10 8b 40 24 8b 40 10 8b 40 08 EIP: [<f0a93c94>]
> >> rpcauth_checkverf+0x34/0x70 [sunrpc] SS:ESP 0068:e64b5eec
> >
> > At a first guess, it looks as though something has scribbled over your
> > credential. Have you tried running this kernel with slab debugging
> > enabled?
> 
> I'm running 2.6.21.5 now with slab debugging on, here's what I got about
> slab corruption:
> 
> Slab corruption: skbuff_head_cache start=ef287b78, len=164
> Redzone: 0x5a2cf071/0x5a2cf071.
> Last user: [<c031710c>](kfree_skbmem+0x3c/0x90)
> 090: 6b 6b 6b 6b 6b 63 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> Single bit error detected. Probably bad RAM.
> Run memtest86+ or a similar memory test tool.
> Prev obj: start=ef287ac8, len=164
> Redzone: 0x170fc2a5/0x170fc2a5.
> Last user: [<c031798b>](__alloc_skb+0x2b/0x100)
> 000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 010: 00 00 00 00 e0 71 e6 ef 00 00 00 00 00 00 00 00
> Next obj: start=ef287c28, len=164
> Redzone: 0x170fc2a5/0x170fc2a5.
> Last user: [<c031798b>](__alloc_skb+0x2b/0x100)
> 000: 84 d0 85 c5 84 d0 85 c5 04 d0 85 c5 2c 0a 73 46
> 010: 6f cd 09 00 00 00 00 00 01 00 00 00 08 e5 72 ee
> 
> How probable is that it is really a bad memory issue?
> Does this report say anything about which RAM chip I should
> investigate/replace ? I have 1x512MB+1x256MB
> 
> Best Regards,
> Maciej

I'd try doing as suggested above: run memtest86 on the computer for a
couple of hours and see what it tells you. That should hopefully give
you enough information to figure out which chips need replacing.

Cheers
  Trond

