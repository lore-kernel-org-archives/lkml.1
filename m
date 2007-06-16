Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbXFPJcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbXFPJcY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 05:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXFPJcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 05:32:16 -0400
Received: from dns.toxicfilms.tv ([150.254.220.184]:45954 "EHLO
	dns.toxicfilms.tv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbXFPJcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 05:32:15 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jun 2007 05:32:14 EDT
Message-ID: <93879EA4546642A48E9511F1AD29E031@pysiak>
From: =?iso-8859-2?Q?Maciej_So=B3tysiak?= <solt2@dns.toxicfilms.tv>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: <linux-kernel@vger.kernel.org>
References: <466FDC76.6020207@dns.toxicfilms.tv> <1181762227.6151.55.camel@heimdal.trondhjem.org>
In-Reply-To: <1181762227.6151.55.camel@heimdal.trondhjem.org>
Subject: Re: 2.6.21.14 NFS related oops
Date: Sat, 16 Jun 2007 11:26:09 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6000.16386
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6000.16386
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>  =======================
>> Code: 10 89 5c 24 10 89 c3 89 7c 24 18 89 d7 89 74 24 14 8b 70 28 75 1a 
>> 8b
>> 4e 08 89 fa 89 d8 ff 51 18 8b 5c 24 10 83 74 24 14 8b 7c 24 <18> 83 c4 1c 
>> c3
>> 89 74 24 0c 8b 40 10 8b 40 24 8b 40 10 8b 40 08 EIP: [<f0a93c94>]
>> rpcauth_checkverf+0x34/0x70 [sunrpc] SS:ESP 0068:e64b5eec
>
> At a first guess, it looks as though something has scribbled over your
> credential. Have you tried running this kernel with slab debugging
> enabled?

I'm running 2.6.21.5 now with slab debugging on, here's what I got about
slab corruption:

Slab corruption: skbuff_head_cache start=ef287b78, len=164
Redzone: 0x5a2cf071/0x5a2cf071.
Last user: [<c031710c>](kfree_skbmem+0x3c/0x90)
090: 6b 6b 6b 6b 6b 63 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Single bit error detected. Probably bad RAM.
Run memtest86+ or a similar memory test tool.
Prev obj: start=ef287ac8, len=164
Redzone: 0x170fc2a5/0x170fc2a5.
Last user: [<c031798b>](__alloc_skb+0x2b/0x100)
000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
010: 00 00 00 00 e0 71 e6 ef 00 00 00 00 00 00 00 00
Next obj: start=ef287c28, len=164
Redzone: 0x170fc2a5/0x170fc2a5.
Last user: [<c031798b>](__alloc_skb+0x2b/0x100)
000: 84 d0 85 c5 84 d0 85 c5 04 d0 85 c5 2c 0a 73 46
010: 6f cd 09 00 00 00 00 00 01 00 00 00 08 e5 72 ee

How probable is that it is really a bad memory issue?
Does this report say anything about which RAM chip I should
investigate/replace ? I have 1x512MB+1x256MB

Best Regards,
Maciej

