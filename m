Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZGAQOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZGAQOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZGAQOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:14:40 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:39616 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZGAQOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KVEIqpf6Y92z+T5m/RB0Tq6+9PTHQOEXWDdkqoFjVFDTTteEde2Vj+BUs/NE6mfbrP
         XqNzDf93HhelEbIBbffAQMjj5fPtL37T1gF3yUonFxWODMIshXG2jQ9khbunOcjlXucV
         T9u1S2CXvDPuL+vOHQUhnwJYuG1yW1J2GDLUI=
MIME-Version: 1.0
In-Reply-To: <20090701151344.GA4372@gondor.apana.org.au>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
	 <6JJ2m5kyucK.A.AtD.NJASKB@chimera>
	 <b6a2187b0907010734w7e7a5bbfm271f44e57e12d1b4@mail.gmail.com>
	 <20090701151344.GA4372@gondor.apana.org.au>
Date: Thu, 2 Jul 2009 00:14:37 +0800
Message-ID: <b6a2187b0907010914x1c68e09k24bc9378e9c0519c@mail.gmail.com>
Subject: Re: [Bug #13627] Tunnel device ignores TCP/UDP traffic
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Paul Martin <pm@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 11:13 PM, Herbert Xu<herbert@gondor.apana.org.au> wrote:

> So you mean that 71f9dacd2e4d233029e9e956ca3f79531f411827 doesn't
> work? Does reverting d55d87fdff8252d0e2f7c28c2d443aee17e9d70f help?

My Linux git already has these two commits, and I tested it with vpnc
(0.5.3) and it connected, but can't ping or ssh to remote. It was
working prior to 2.6.30.

Tested reverting d55d87fdff8252d0e2f7c28c2d443aee17e9d70f, but still
no good. Also reverted 71f9dacd2e4d233029e9e956ca3f79531f411827, still
no good.

> If not can you elaborate on what you mean by not working?

It seems the tunnel is not setup correctly, but I'll have to revert
back to 2.6.29+ to verify.

On kvm (again, it could be KVM which I'm not 100% sure. kvm-87),  it
won't ping to/from the guest system with host ... Used to work before
2.6.31-rc1 with guest net model=e1000 and model=virtio, but with
2.6.31-rc1, only works with model=virtio. .. This could be an
_unrelated_ issue though.

/usr/local/kvm/bin/qemu-system-x86_64 \
        -localtime \
        -net nic,vlan=0,model=e1000 \
        -net tap,script=/root/scripts2/tunx \


Thanks,
Jeff.
