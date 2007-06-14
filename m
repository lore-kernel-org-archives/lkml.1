Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbXFNPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbXFNPet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbXFNPen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:34:43 -0400
Received: from calisto.ae.poznan.pl ([150.254.37.3]:40765 "EHLO
	calisto.ae.poznan.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbXFNPem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:34:42 -0400
Message-ID: <46716010.6030307@dns.toxicfilms.tv>
Date: Thu, 14 Jun 2007 17:34:40 +0200
From: Maciej Soltysiak <solt2@dns.toxicfilms.tv>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.14 NFS related oops
References: <466FDC76.6020207@dns.toxicfilms.tv> <1181762227.6151.55.camel@heimdal.trondhjem.org>
In-Reply-To: <1181762227.6151.55.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust pisze:
> On Wed, 2007-06-13 at 14:00 +0200, Maciej Soltysiak wrote:
>   
>> Hi,
>>
>> If anyone is interested I got this OOPS while running a torrent 
>> (btdownloadcurses)
>> application writing directly to a NAS mounted via nfs3.
>>
>> The client machine is 2.6.21.14 and it is mounted with options:
>> wsize=8192,rsize=8192,hard,intr,tcp
>>     
>
> Hmm. The Oops says '2.6.20.14-cks1'
>
> Firstly, does that have any extra out-of-tree patches?
> Secondly, is it reproducible with 2.6.21 or a more recent kernel?
>
>   
Ah, yes, 2.6.20.14 not 2.6.21.14 and it does contain 2 extra things:
- Con Kolivas' -cks1 (server version)
- reiser4 code, one mounted filesystem.
>> After that, the application hung and i am unable to cd into the mounted 
>> nfs directory
>> nor unmount it (busy), nor kill the app (kill -9 fails, process in D state)
>>
>> Best regards,
>> Maciej
>>
>> BUG: unable to handle kernel paging request at virtual address 5018f248
>>  printing eip:
>> f0a93c94
>> *pde = 00000000
>> Oops: 0002 [#1]
>> Modules linked in: binfmt_misc sit nfs lockd nfs_acl sunrpc w83627ehf 
>> i2c_isa i2c_viapro i2c_core via_agp agpgart rtc
>> CPU:    0
>> EIP:    0060:[<f0a93c94>]    Not tainted VLI
>> EFLAGS: 00010206   (2.6.20.14-cks1 #15)
>> EIP is at rpcauth_checkverf+0x34/0x70 [sunrpc]
>> eax: d2f4447c   ebx: c655d584   ecx: 00000000   edx: f0aa9f60
>> esi: e91ea640   edi: d2f44474   ebp: ede2f228   esp: e64b5eec
>> ds: 007b   es: 007b   ss: 0068
>> Process rpciod/0 (pid: 1005, ti=e64b4000 task=efe95a90 task.ti=e64b4000)
>> Stack: 00000286 ede2f8a0 ede2f8a0 00000286 c655d584 121d0da3 00000820 
>> f0a8d7fd
>>        f0a93d60 f08bae07 00000286 c655d5cc 00000286 00000286 f08c0520 
>> c655d584
>>        00000000 c655d5ec f0a93260 f0a9306f efe95a90 ee2d5740 e092ffb0 
>> c034e11c
>> Call Trace:
>>  [<f0a8d7fd>] call_decode+0x27d/0x5e0 [sunrpc]
>>  [<f0a93d60>] rpcauth_unbindcred+0x20/0x60 [sunrpc]
>>  [<f08bae07>] nfs_readpage_result_full+0xf7/0x120 [nfs]
>>  [<f08c0520>] nfs3_xdr_readres+0x0/0x160 [nfs]
>>  [<f0a93260>] rpc_async_schedule+0x0/0x10 [sunrpc]
>>  [<f0a9306f>] __rpc_execute+0x5f/0x250 [sunrpc]
>>  [<c034e11c>] schedule+0x21c/0x450
>>  [<c01283aa>] run_workqueue+0x7a/0x110
>>  [<c0128a07>] worker_thread+0x137/0x160
>>  [<c01176b0>] default_wake_function+0x0/0x10
>>  [<c01288d0>] worker_thread+0x0/0x160
>>  [<c012b329>] kthread+0xa9/0xe0
>>  [<c012b280>] kthread+0x0/0xe0
>>  [<c0103a97>] kernel_thread_helper+0x7/0x10
>>  =======================
>> Code: 10 89 5c 24 10 89 c3 89 7c 24 18 89 d7 89 74 24 14 8b 70 28 75 1a 8b
>> 4e 08 89 fa 89 d8 ff 51 18 8b 5c 24 10 83 74 24 14 8b 7c 24 <18> 83 c4 1c c3
>> 89 74 24 0c 8b 40 10 8b 40 24 8b 40 10 8b 40 08 EIP: [<f0a93c94>]
>> rpcauth_checkverf+0x34/0x70 [sunrpc] SS:ESP 0068:e64b5eec
>>     
>
> At a first guess, it looks as though something has scribbled over your
> credential. Have you tried running this kernel with slab debugging
> enabled?
>
>   
No, i will turn it on, though. The server crashes on heavy NFS traffic 
(eg. nightly rsync backup)
It crashed again today, but the oops did not get written to kern.log
> Cheers
>   Trond
>   
Thanks for your reply and best regards,
Maciej

