Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbYFSQC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbYFSQC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 12:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761528AbYFSQCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 12:02:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:12437 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761535AbYFSQCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 12:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P5PSLDjacIGKLhuymp0h3dtwdkte4gKgMO9DRh/dUDsmig0dljGiQpXCmWnBSIgtjK
         qm9Pz5anivAqz/sNJGpavnGHMSprhOolZb3V8SsgzQqGPzEKKVSaV7TXC/zneyBNbW4M
         VUYAcSdGeWdFR7w8YIEev8pziMK3iYsIqF7wE=
Message-ID: <a4423d670806190902l48c542e0i6a7380a2d3e7f520@mail.gmail.com>
Date: Thu, 19 Jun 2008 20:02:44 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>, kernel-testers@vger.kernel.org,
       sparclinux@vger.kernel.org,
       "kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
In-Reply-To: <a4423d670806190707k7ae6da8cud80a826a1603d941@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670806190707k7ae6da8cud80a826a1603d941@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/19 Alexander Beregalov <a.beregalov@gmail.com>:
> Hi
>
> Sun Ultra 10 can not boot the last 2.6.26-rc6-git, it hangs right after
>
> Console: colour dummy device 80x25
> console handover: boot [earlyprom0] -> real [tty0]
<cut>
> I have done bisect:
>
> a051bc5bb1ac6dc138d529077fa20cbbc6622d95 is first bad commit
> commit a051bc5bb1ac6dc138d529077fa20cbbc6622d95
> Author: David S. Miller <davem@davemloft.net>
> Date:   Wed May 21 18:14:28 2008 -0700
>
>    sparc64: Fix kernel thread stack termination.
>
>    Because of the silly way I set up the initial stack for
>    new kernel threads, there is a loop at the top of the
>    stack.
>
>    To fix this, properly add another stack frame that is copied
>    from the parent and terminate it in the child by setting
>    the frame pointer in that frame to zero.
>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
> :040000 040000 beba7e8c740188a7c19a3569f08b1edd25b8000d
> aed42d5af3ab9a84ccb3dfe07eb444a78f9001fa M      arch
>

I have reverted this commit and
2.6.26-rc6-00233-g99d3b2d works fine. It can boot.
