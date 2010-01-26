Return-Path: <linux-kernel-owner+w=401wt.eu-S1752039Ab0AZDCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0AZDCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441Ab0AZDCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:02:36 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:40289 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0AZDCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BPGFeG2lWWVwuJVu+GuFQMM8b8XRH26wotllYqhVcR4V8vNSh/CSqIQtulWetRiQEx
         mdJsCaKA5XkOw+Wb9rRzbKvqV8lzgs0gl4XMmHP5phW182KC1n8uCSxNwy9IG2HRWz0h
         op3wGsSgMYJLZ7JI+eT873o9BF9oiJjjS1bX0=
MIME-Version: 1.0
In-Reply-To: <1264455681-10578-1-git-send-email-hschauhan@nulltrace.org>
References: <1264455681-10578-1-git-send-email-hschauhan@nulltrace.org>
Date: Tue, 26 Jan 2010 11:02:34 +0800
Message-ID: <2375c9f91001251902p3d632fbdr4c34e43c0973e68f@mail.gmail.com>
Subject: Re: [PATCH] scripts/kallsyms build warning fix
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Himanshu Chauhan <hschauhan@nulltrace.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, greg@kroah.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 5:41 AM, Himanshu Chauhan
<hschauhan@nulltrace.org> wrote:
> Hi all,
>
> This is a small patch that fixes the build warning
> of scripts/kallsyms.c
>
> Regards
> Himanshu
>
> Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>
> ---
>  scripts/kallsyms.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index 86c3896..e3902fb 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -108,8 +108,10 @@ static int read_symbol(FILE *in, struct sym_entry *s)
>        rc = fscanf(in, "%llx %c %499s\n", &s->addr, &stype, str);
>        if (rc != 3) {
>                if (rc != EOF) {
> -                       /* skip line */
> -                       fgets(str, 500, in);
> +                       /* skip line. sym is used as dummy to
> +                        * shut of "warn_unused_result" warning.
> +                        */
> +                       sym = fgets(str, 500, in);
>                }
>                return -1;
>        }

Why not use the return value to do some useful checking?
