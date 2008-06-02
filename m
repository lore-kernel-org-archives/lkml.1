Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbYFBGxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbYFBGxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYFBGx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:53:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823AbYFBGx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:53:27 -0400
Message-ID: <48439890.6030904@redhat.com>
Date: Mon, 02 Jun 2008 08:52:00 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yan Li <elliot.li.tech@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Ritesh Raj Sarraf <rrs@researchut.com>,
       Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
       rjmaomao@gmail.com, Alasdair G Kergon <agk@redhat.com>,
       dm-crypt@saout.de
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
References: <20080602030738.GA7761@yantp.cn.ibm.com>
In-Reply-To: <20080602030738.GA7761@yantp.cn.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yan Li wrote:
> On Thu, 28 Feb 2008 23:20:48 -0800, Andrew Morton wrote:
>> On Thu, 28 Feb 2008 19:24:03 +0530 Ritesh Raj Sarraf <rrs@researchut.com> wrote:
>>> I noted kernel soft lockup messages on my laptop when doing a lot of I/O 
>>> (200GB) to a dm-crypt device. It was setup using LUKS.
>>> The I/O never got disrupted nor anything failed. Just the messages.
> 
> I met the same problem yesterday.
> 
>> Could be a dm-crypt problem, could be a crypto problem, could even be a
>> core block problems.
> 
> I think it's due to heavy encryption computation that run longer than
> 10s and triggered the warning. By heavy I mean dm-crypt with
> aes-xts-plain, 512b key size.
> 
> This is a typical soft lockup call trace snip from dmesg:
> Call Trace:
>  [<ffffffff882c60b6>] :xts:crypt+0x9d/0xea
>  [<ffffffff882b5705>] :aes_x86_64:aes_encrypt+0x0/0x5
>  [<ffffffff882b5705>] :aes_x86_64:aes_encrypt+0x0/0x5
>  [<ffffffff882c622e>] :xts:encrypt+0x41/0x46
>  [<ffffffff8828273f>] :dm_crypt:crypt_convert_scatterlist+0x7b/0xc7
>  [<ffffffff882828ae>] :dm_crypt:crypt_convert+0x123/0x15d
>  [<ffffffff88282abd>] :dm_crypt:kcryptd_do_crypt+0x1d5/0x253
>  [<ffffffff882828e8>] :dm_crypt:kcryptd_do_crypt+0x0/0x253
>  [<ffffffff802448e5>] run_workqueue+0x7f/0x10b
> ... (omitted)

Please could you try if  patch here helps and doesn't cause performance degradation?

http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.25/dm-crypt-add-cond_resched.patch

...
> Anybody see a data corruption?

It shouldn't cause any corruption of data.

Milan
