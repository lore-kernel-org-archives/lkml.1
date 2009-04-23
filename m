Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZDWGSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZDWGSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZDWGSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:18:10 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:58241 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZDWGSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XuK1DBJKvJOB78jnMD7vH+A9linQxtZmoyiy0fCZRzH9A1QMD+fdwMiMbABJeKGMP1
         wXoYMQls7LNiwamTdn6KsNvYkr83ilJhy9q+9KJSlH2mrcpDzMHFteUMlzIFgmSKEajN
         g4cC/jxtUCN/DD7x5kAT1HBGN7nsIFUnOuWDg=
MIME-Version: 1.0
In-Reply-To: <49EF6A4D.3030606@suse.de>
References: <49EF6A4D.3030606@suse.de>
Date: Thu, 23 Apr 2009 14:18:03 +0800
Message-ID: <f17812d70904222318n4b742c17y647b8a8ca5273112@mail.gmail.com>
Subject: Re: [PATCH 1/7] mach-mmp: add parameter to clksrc_read()
From: Eric Miao <eric.y.miao@gmail.com>
To: coly.li@suse.de
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Miao <eric.miao@marvell.com>,
       Ingo Molnar <mingo@elte.hu>, Magnus Damm <damm@igel.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks to be already fixed by Magnus Damm and merged in recent -rc3.

On Thu, Apr 23, 2009 at 3:04 AM, Coly Li <coly.li@suse.de> wrote:
> After the patch to add parameter to uv_read_rtc(), I did a grep and found
> several similar issues.
>
> This patch modifies parameter of clksrc_read() from 'void' to 'struct
> clocksource *cs', which fixes compile warning for incompatible parameter type.
>
> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: Eric Miao <eric.miao@marvell.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/arm/mach-mmp/time.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
> index b03a6ed..a8400bb 100644
> --- a/arch/arm/mach-mmp/time.c
> +++ b/arch/arm/mach-mmp/time.c
> @@ -136,7 +136,7 @@ static struct clock_event_device ckevt = {
>        .set_mode       = timer_set_mode,
>  };
>
> -static cycle_t clksrc_read(void)
> +static cycle_t clksrc_read(struct clocksource *cs)
>  {
>        return timer_read();
>  }
>
> --
> Coly Li
> SuSE Labs
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
