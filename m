Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbYIBNhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbYIBNhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYIBNhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:37:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:8134 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYIBNhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:37:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gEe0b6qbwixFVPritn7tgoA56ZqT80NA/V+KDHcw61O/ntZoGJH4/EUyTQ8P7yjvvZ
         FT7NL1WGMPhDtmj1iND5ZNys38tfXlkYM7fGYHfHb1w+vgTnr4fobKTBLTlEClf09uhM
         gM11QcqLsFGJq2JD3v5YbaNyHzP9oXHB44u7o=
Message-ID: <8bd0f97a0809020637n2c7e29bexe87bd3dca50cee88@mail.gmail.com>
Date: Tue, 2 Sep 2008 09:37:01 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH 1/1] ALSA: add dummy function to support shared mmap in nommu Blackfin arch (v2)
Cc: tiwai@suse.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       "Cliff Cai" <cliff.cai@analog.com>
In-Reply-To: <1220349522-17995-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220349522-17995-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2008 at 5:58 AM, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
>
> v1-v2:
>  - only adding this dummy function in nommu arch
>
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  sound/core/pcm_native.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> index c49b9d9..1e88cde 100644
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
> @@ -3391,6 +3391,14 @@ out:
>  }
>  #endif /* CONFIG_SND_SUPPORT_OLD_API */
>
> +#ifndef CONFIG_MMU
> +unsigned long dummy_get_unmapped_area(struct file *file, unsigned long addr,
> +                                     unsigned long len, unsigned long pgoff, unsigned long flags)
> +{
> +       return 0;
> +}
> +#endif

if you had:
#else
# define dummy_get_unmapped_area NULL
#endif
then you could avoid #ifdef in the rest of the file ...
-mike
