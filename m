Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbXGNKAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbXGNKAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 06:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbXGNKAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 06:00:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:38413 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbXGNKAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 06:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=SsTWtOEASlVybP84BSKjDjnV35vzTSx8cn8R9pSSVHGj3/xkflOXzupMca3q/SLhCHr75lmL2ouDA1itpr4UxlxyECIw+Rq2DGUnTrI/Rec1f5HiVpuVsshKHg5doxut9woZ2ccAMkFTgXAVxFdaSTPtBoXza6kKx1/b6/Jl/Ck=
Message-ID: <46989E90.2020906@googlemail.com>
Date: Sat, 14 Jul 2007 11:59:44 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] broken lilo check on make install
References: <46969586.5050507@googlemail.com> <4697FCBD.7050003@zytor.com>
In-Reply-To: <4697FCBD.7050003@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Gabriel C wrote:
>   
>> I don't use and don't have lilo installed on this system. The attached
>> patch fixes the problem for me.
>>
>>     
>
> You also don't have a /sbin/installkernel, which is arguably a bug too.
>  However, the patch mostly makes sense, although I would suggest putting
> a "sync" in the else clause.
>   

Ok , I've changed the patch to use sync.

> With that caveat, Acked-by: H. Peter Anvin <hpa@zytor.com>
>
>   

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

 arch/i386/boot/install.sh |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/i386/boot/install.sh b/arch/i386/boot/install.sh
index 5e44c73..cb55f67 100644
--- a/arch/i386/boot/install.sh
+++ b/arch/i386/boot/install.sh
@@ -51,4 +51,11 @@ fi
 cat $2 > $4/vmlinuz
 cp $3 $4/System.map
 
-if [ -x /sbin/lilo ]; then /sbin/lilo; else /etc/lilo/install; fi
+if [ -x /sbin/lilo ]; then
+       /sbin/lilo
+elif [ -x /etc/lilo/install ]; then
+       /etc/lilo/install
+else
+       sync
+       echo "Cannot find LILO."
+fi

