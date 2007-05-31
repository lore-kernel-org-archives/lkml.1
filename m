Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbXEaSVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbXEaSVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbXEaSV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:21:28 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:36552 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350AbXEaSV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:21:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KktRm8Mc3vOjVkE0r0hXZXwwq3+f/sdLIqAeVudGCPACPtPZLY0mRWrauu4ROWvVys4uu4hgVIwWjRa6nY2LDgmK/UIiMMxofa3h0cBt60Z49nNPQyPd+ILO3msf9NfNFc864fnd3LnIIFBEjQePNQMeSzH6vr7N97MXS5U9w8M=
Message-ID: <a781481a0705311121h3a977461t82a2a02b9035df8@mail.gmail.com>
Date: Thu, 31 May 2007 23:51:26 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>
In-Reply-To: <4cefeab80705310534jb92535dy45fcf5fbe363b55b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <4cefeab80705310534jb92535dy45fcf5fbe363b55b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> [...]
> The author (Markus Oberhumer) of LZO  provided these comments for this patch:
>
> ---
> I've only briefly looked over it, but it's obvious that your version does not
> work on architechtures which do not allow unaligned access (arm, mips, ...).
>
> As for further quality assurance, your version should generate byte-identical
> object code to LZO 2.02 when using the same compiler & flags. So you could do
> some semi-automatic testing by compiling with -ffunction-sections and use
> "objcopy --only-section .text.XXX" to compare the md5sum of all generated
> functions. This also works fine with crosscompilers.
>
> Finally I'm not too happy that you renamed the functions and #defines like
> LZO1X_WORKMEM_SIZE - please stay compatible with the official library version.

As suggested by Johannes earlier, it'd be great if you could submit
the various changes (as per Changelog) as _individual patches_ on
the original userspace code. That would be easier for others to review,
and there's lesser chances of bugs / issues leaking in that way.

As for "byte-identical object code", I definitely do *not* think it is
necessarily a requirement / good idea. As long as all the changes
you make are reviewed individually / closely by people here on this
list, there's very low chances of any bugs creeping in. [ F.e. I see
nothing wrong in removing the usage of "register" -- that could clearly
lead to different object code, but with no bugs introduced. ]
