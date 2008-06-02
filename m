Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYFBPEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYFBPEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYFBPEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:04:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:49821 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbYFBPEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mLOQcmyQAd/ZABaKcmexUpwnysunRn9gUTlS01JsEm2kVYsMCynpZWlxW10cZAsXyGZns50RGmDxuqblUiTd9KekK93f6jBM/aNlKrIhc8fCXmI6JJc0HYDoetRPllM+oJKNVUjVupKhe6FpgjnYvOD+k3ivi087OCkXavm3Ayg=
Message-ID: <32209efe0806020804m751d71c4k1fe8339627f6dbd1@mail.gmail.com>
Date: Mon, 2 Jun 2008 08:04:18 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Zabele, Stephen (US SSA)" <steve.zabele@baesystems.com>
Subject: Submitting fixes for bugs: Re: tun device patch for IPv6
Cc: maxk@qualcomm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 6:53 AM, Zabele, Stephen (US SSA)
<steve.zabele@baesystems.com> wrote:
> Natalie,
>
>>Steve,
>>Can you please submit the patch to LKML and to Maxim
> (maxk@qualcomm.com) >via email (if you haven't already)?
>
> The patch is accessible from the bottom of the bugzilla web page, but
> I'm also providing it again here for reference. I' not sure how to
> submit it to LKML other than through the bugzilla mechanism. Can you
> provide me a pointer??
>
> Thanks!
>
> Steve
>

Hi Steve,
This issue is pretty generic. Bug reporters often produce fixes, that
remain in bugzilla not being harvested, simply because bugzilla is not
designed for submitting patches. Even developers who work on bugzilla
and leave their patches attached to the bug don't get those
incorporated until they submit it conventional way.

To submit the patch properly follow
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt. There are
other pointers like http://linux.yyz.us/patch-format.html,
http://lxr.linux.no/linux/Documentation/SubmittingPatches. You can
look at any submitted patch as a sample and examine the format; note
that added/changed/removed lines produced with diffstat.

Maintainers deal with great number of patches, so in order to be able
to use your patch they have go receive it in proper format i.e. with
conventional comments and headers, such that it complies with source
keeping process (not mentioning that it should apply to latest tree,
so they don't have to port it...)
Any patch that fixes a problem is valuable, so by submitting it proper
way you'll make sure (1) your patch will get the best review possible
(2)  you will get proper credit for it. Then you post it to LKML and
CC to subsystem maintainer and/or developers heavily involved with
this module.
Thanks,
--Natalie

> --- Cut here ---
>
> --- a/drivers/net/tun.c 2008-02-11 01:06:32.000000000 -0500
> +++ b/drivers/net/tun.c 2008-03-18 15:30:55.000000000 -0400
> @@ -243,8 +243,26 @@
>
>                if(memcpy_fromiovec((void *)&pi, iv, sizeof(pi)))
>                        return -EFAULT;
> -       }
> -
> +
> +        } else if ((tun->flags & TUN_TYPE_MASK) == TUN_TUN_DEV) {
> +                if (iv->iov_len) {
> +                        unsigned char verbuf;
> +
> +                        if (copy_from_user((void *)&verbuf,
> iv->iov_base, sizeof(verbuf)))
> +                                return -EFAULT;
> +
> +                        switch (verbuf & 0xf0) {
> +                          case 0x40:
> +                            break;
> +                          case 0x60:
> +                            pi.proto = htons(ETH_P_IPV6);
> +                            break;
> +                          default:
> +                            return -EINVAL;
> +                        }
> +                }
> +        }
> +
>        if ((tun->flags & TUN_TYPE_MASK) == TUN_TAP_DEV)
>                align = NET_IP_ALIGN;
>
>
