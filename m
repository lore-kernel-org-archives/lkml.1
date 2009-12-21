Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZLUPXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZLUPXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZLUPXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:23:21 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:61049 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbZLUPXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:23:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lvhzZ1daf1sAJm8eVahV8LV/mM4vAAWsfarVUr+C4bKxsIFyS7XVZNN74++KgQ+4pg
         Ocyr2mHyDOnVhMPWLNfov/LVRCssTk1ZtsXaLAVQzzEstwpeM+vOBklZTlOcmEvP8/D7
         dKle7R+Q3WOeVvi52+UaXL0pP3gCn8cmex2Jk=
MIME-Version: 1.0
In-Reply-To: <1261387359-1933-1-git-send-email-wenji.huang@oracle.com>
References: <1261387359-1933-1-git-send-email-wenji.huang@oracle.com>
Date: Mon, 21 Dec 2009 16:23:17 +0100
X-Google-Sender-Auth: 12fca45567e8cd9c
Message-ID: <520f0cf10912210723j1ac91183n3d7970b96b95ef23@mail.gmail.com>
Subject: Re: [PATCH] perf: fix incorrect return value for else case
From: John Kacur <jkacur@redhat.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 10:22 AM, Wenji Huang <wenji.huang@oracle.com> wrote:
> Return original cmd instead of adding prefix.
>
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  tools/perf/builtin-help.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
> index 9f810b1..ca77df5 100644
> --- a/tools/perf/builtin-help.c
> +++ b/tools/perf/builtin-help.c
> @@ -317,7 +317,7 @@ static const char *cmd_to_page(const char *perf_cmd)
>        else if (is_perf_command(perf_cmd))
>                return prepend("perf-", perf_cmd);
>        else
> -               return prepend("perf-", perf_cmd);
> +               return perf_cmd;
>  }
>
>  static void setup_man_path(void)
> --
> 1.5.6

Sorry - I believe we should NAK this patch.
It would turn the following

./perf nonsuchcmd --help
No manual entry for perf-nonsuchcmd

into

./perf nonsuchcmd --help
No manual entry for nonsuchcmd

The former is correct, the name of the man page includes the prefix "perf-"

NAK

(cc-ing Frederic in case he sees it differently)

Thank You

John Kacur
