Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZI3LkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZI3LkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 07:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZI3LkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 07:40:17 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:42486 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZI3LkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 07:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QwKYqAjg+ad0XpIC1EUHqltpqWC3I3DsHN6hoLtjZeDHegikEr62HwZOkQTC0Ww7sA
         BpxdaaHjY7pfvnDKVhDC0famQbikUtCHi7NHCsdIaAc182mHLbS2Eu7hnLW5VTY/Sv93
         Phe6loC42aaeAlTM1SkRVErVyAgVRSSFgAiM0=
MIME-Version: 1.0
In-Reply-To: <4AC1D0F5.4050709@gmail.com>
References: <38b2ab8a0909290109m3f82c161j4fb0f1266152877e@mail.gmail.com>
	 <4AC1D0F5.4050709@gmail.com>
Date: Wed, 30 Sep 2009 13:40:18 +0200
Message-ID: <38b2ab8a0909300440p69820fe6h19e4eec72fc16f87@mail.gmail.com>
Subject: Re: WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct
From: Francis Moreau <francis.moro@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 11:18 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Francis Moreau a écrit :
>> Hello,
>>
>> I got this kernel warning when stopping nfsd:
>>
>> [260104.553720] WARNING: at net/ipv4/af_inet.c:154
>> inet_sock_destruct+0x164/0x182()
>> [260104.553722] Hardware name: P5K-VM
>> [260104.553724] Modules linked in: jfs loop nfsd lockd nfs_acl
>> auth_rpcgss exportfs sunrpc [last unloaded: microcode]
>> [260104.553736] Pid: 858, comm: nfsd Tainted: G   M       2.6.31 #13
>> [260104.553738] Call Trace:
>> [260104.553743]  [<ffffffff813ed53a>] ? inet_sock_destruct+0x164/0x182
>> [260104.553748]  [<ffffffff81044471>] warn_slowpath_common+0x7c/0xa9
>> [260104.553751]  [<ffffffff810444b2>] warn_slowpath_null+0x14/0x16
>> [260104.553754]  [<ffffffff813ed53a>] inet_sock_destruct+0x164/0x182
>> [260104.553759]  [<ffffffff8138e1c0>] __sk_free+0x23/0xe7
>> [260104.553762]  [<ffffffff8138e2fd>] sk_free+0x1f/0x21
>> [260104.553765]  [<ffffffff8138e3c7>] sk_common_release+0xc8/0xcd
>> [260104.553769]  [<ffffffff813e4459>] udp_lib_close+0xe/0x10
>> [260104.553772]  [<ffffffff813ecfe2>] inet_release+0x55/0x5c
>> [260104.553775]  [<ffffffff8138b746>] sock_release+0x1f/0x71
>> [260104.553778]  [<ffffffff8138b7bf>] sock_close+0x27/0x2b
>> [260104.553782]  [<ffffffff810d0641>] __fput+0xfb/0x1c0
>> [260104.553787]  [<ffffffff8104a197>] ? local_bh_disable+0x12/0x14
>> [260104.553790]  [<ffffffff810d0723>] fput+0x1d/0x1f
>> [260104.553810]  [<ffffffffa0014035>] svc_sock_free+0x40/0x56 [sunrpc]
>> [260104.553827]  [<ffffffffa001dea0>] svc_xprt_free+0x43/0x53 [sunrpc]
>> [260104.553843]  [<ffffffffa001de5d>] ? svc_xprt_free+0x0/0x53 [sunrpc]
>> [260104.553847]  [<ffffffff811b4641>] kref_put+0x43/0x4f
>> [260104.553863]  [<ffffffffa001d224>] svc_close_xprt+0x55/0x5e [sunrpc]
>> [260104.553879]  [<ffffffffa001d27d>] svc_close_all+0x50/0x69 [sunrpc]
>> [260104.553894]  [<ffffffffa0012922>] svc_destroy+0x9e/0x142 [sunrpc]
>> [260104.553910]  [<ffffffffa0012a7f>] svc_exit_thread+0xb9/0xc2 [sunrpc]
>> [260104.553922]  [<ffffffffa00707b1>] ? nfsd+0x0/0x151 [nfsd]
>> [260104.553932]  [<ffffffffa00708e8>] nfsd+0x137/0x151 [nfsd]
>> [260104.553936]  [<ffffffff8105ad28>] kthread+0x94/0x9c
>> [260104.553941]  [<ffffffff8100c1fa>] child_rip+0xa/0x20
>> [260104.553944]  [<ffffffff81047b00>] ? do_exit+0x5d7/0x691
>> [260104.553948]  [<ffffffff81039cf8>] ? finish_task_switch+0x6a/0xc7
>> [260104.553953]  [<ffffffff8100bb6d>] ? restore_args+0x0/0x30
>> [260104.553956]  [<ffffffff8105ac94>] ? kthread+0x0/0x9c
>> [260104.553959]  [<ffffffff8100c1f0>] ? child_rip+0x0/0x20
>>
>> It happens on 2.6.31 and older kernels as well though I don't remember
>> when it really started.
>
> Could you please try following patch ?
>

No trace of this bug has been seen so far.

thanks
-- 
Francis
