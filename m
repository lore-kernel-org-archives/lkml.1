Return-Path: <linux-kernel-owner+w=401wt.eu-S933369AbXCIEgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369AbXCIEgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXCIEgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:36:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:23543 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369AbXCIEgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:36:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BmVN4CspsTidhjcv7wRI2m2ujdfPTVE4vQ4hB2i1ENqXCIQyMGpXJeDRJ6HiZfwUWIgKCLxXD0EgY70qRjUuOpoub71fqbkRrI5MIH/PY2GKAfU/2/g21NNgLH0MTaTEIwKm7K4XvekT+zYDWTISPFrypkbl8hIUEJcNTqwMTSg=
Message-ID: <2de37a440703082036w2a69ecd4wff894f71e6fdd4d5@mail.gmail.com>
Date: Fri, 9 Mar 2007 05:36:09 +0100
From: Michael <iogl64nx@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

I found a little "hickup" in the mm kernel series since 2.6.21-rc2-mm1/mm2.
1.) appeared while boot (no VFS mounted at time)

BUG: at arch/i386/mm/highmem.c:61 kmap_atomic()
 [<c011583b>]  [<c03340b5>]  [<c033455c>]  [<c0297d57>]  [<c032e10f>]
[<c0332728>]  [<c033be08>]  [<c032500b>]  [<c0319d59>]  [<c01425c5>]
[<c014395d>]  [<c01056fb>]  [<c0516540>]  [<c01035a7>]  [<c0516540>]
[<c0100be6>]  [<c0100ddd>]  [<c0516d95>]  [<c0516540>]
=======================
BUG: at arch/i386/mm/highmem.c:61 kmap_atomic()
 [<c011583b>]  [<c03340b5>]  [<c033455c>]  [<c032e10f>]  [<c0332728>]
[<c033be08>]  [<c011c1e1>]  [<c01425c5>]  [<c014395d>]  [<c01056fb>]
[<c0516540>]  [<c01035a7>]  [<c0516540>]  [<c0100be6>]  [<c0100ddd>]
[<c0516d95>]  [<c0516540>]  =======================

2.) some time after when I run some ups i hit this
BUG: atomic counter underflow at:

[<f94140a6>]  [<f9414657>]  [<c03d6611>]  [<c03d4c85>]  [<c04175c3>]
[<c03d619b>]  [<c03d5c6a>]  [<c03ca100>]  [<c03ca0b0>]  [<c017657b>]
[<c01149e6>]  [<c017663c>]  [<c01768f2>]  [<c0102ba2>]  [<c0430000>]
=======================

Then in 2.6.21-rc3-mm2

Now for rc3-mm2 the bug of under 1.) of rc2-mm1/mm2 gone.

But still here -> underflow..*huh*
BUG: atomic counter underflow at:
 [<b0270295>]  [<b02da598>]  [<b02db0b8>]  [<b0281b4e>]  [<f1fdd389>]
[<b04081c7>]  [<b0140540>]  [<b0140318>]  [<b015a099>]  [<b015ab57>]
[<b0102ba2>]  [<b0400000>]  =======================

Also I found some mis-beheviour of the Attansic "atl1 driver"
Maybe I address it wrong but I don't know (sure) who is the real maintainer.
Well I looked at atl1_main.c but to be honest there aren't obvious
information to whom/where I should address such issues.

Could you please so kind to address it to the right person?

atl1: hw csum wrong pkt_flag:1600, err_flag:80

All these hickups never appeared in the latest vanilla kernel
2.6.21-rc2 + even the last git-updates
2.6.21-rc3-git3 there is also not such behaviour

Thanks for your patience.

Best regards
Michael
