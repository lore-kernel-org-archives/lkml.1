Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYH3VGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYH3VGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYH3VGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:06:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:50355 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYH3VGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RjXC82q5a00vLsWKJxNUAQ8K5tqHvVkAN6UD0nExnaAUXu+BeIK0eZGGHR41DyH48X
         l54KNrO+qxSB2oQNfZnqxI9xdrZBIKIr9Xc7gfN3o32ekJLNz9ufc3OkYE7ax2gfyMuS
         AjUlT6q+S+858fD12lo4+4k47uDqsNUfrohVY=
Message-ID: <21d7e9970808301406x6310c7b9w2ef663cbf40b5e61@mail.gmail.com>
Date: Sun, 31 Aug 2008 07:06:26 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Gene Heskett" <gene.heskett@verizon.net>
Subject: Re: Linux-2.6.27-rc5, drm errors in log
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaswinder Singh" <jaswinder@infradead.org>, xorg@lists.freedesktop.org
In-Reply-To: <200808301452.04634.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808301452.04634.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 4:52 AM, Gene Heskett <gene.heskett@verizon.net> wrote:
> Greetings all;
>
> A re-repeat of a previous posting which has not drawn a comment. With added
> content, added CC to a patch author, and some new questions.
>
> Machine is an F8 install, Athlon xp-2800 on an nforce2 motherboard, running
> an older radeon 9200SE (RV280 based) video card.  No problems if I reboot
> to 2.6.27-rc4.
>
> I'm drowning in these errors:
>
> Aug 30 13:21:05 coyote kernel: [14927.850078] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:21:05 coyote kernel: [14927.861335] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:21:05 coyote kernel: [14928.060233] [drm] wait idle failed status : 0x80076100 0x00000000
> Aug 30 13:21:07 coyote kernel: [14929.557075] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:21:07 coyote kernel: [14929.568869] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:21:08 coyote kernel: [14931.028882] [drm] wait for fifo failed status : 0x80036100 0x00000000
> Aug 30 13:21:08 coyote kernel: [14931.039896] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:21:18 coyote kernel: [14940.515114] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:27:27 coyote kernel: [15310.125656] [drm] wait for fifo failed status : 0x80066107 0x00000000
>
> I have rebuilt and rebooted several times now, adjusting things like the
> timer frequency, and modular vs builtin for ati and drm stuff with no
> apparent effect.

Before now we never had this error in here, and its showing up a real
problem with your card, reading the r300 register doesn't matter at
all,
as things have already gone wrong by the time you hit this debug.

The question is if you add the 3 lines into radeon_cp.c at the same
place in -rc4 without the other patches does it still happen..
       DRM_INFO("wait for fifo failed status : 0x%08X 0x%08X\n",
                RADEON_READ(RADEON_RBBM_STATUS),
                RADEON_READ(R300_VAP_CNTL_STATUS));

If so I'll just make DRM_INFO into DRM_DEBUG for now and we can work
it out later.

Dave.
