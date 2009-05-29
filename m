Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbZE2N22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbZE2N22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbZE2N2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:28:20 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:49026 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785AbZE2N2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OSx027EPFEryIlxBQyFMmENFaUko8x8k/OVl4FnqfgWLeSP2agARMfvQfjrZ3wrPjo
         3fNtJqLN07hDG/xrJUW7M/8N7zo2avmRL84NCnwA5Bol7FltnV753t6XjIpiCdXSsCQl
         XKMkmI0xOGRv/6QLk0QAoR+FqQOQh3LjxGC9U=
MIME-Version: 1.0
In-Reply-To: <4A1F9FA6.3030906@cn.fujitsu.com>
References: <4A1F9FA6.3030906@cn.fujitsu.com>
Date: Fri, 29 May 2009 15:28:20 +0200
Message-ID: <c62985530905290628y3e203defrc00835d3d7596aed@mail.gmail.com>
Subject: Re: [PATCH 1/2] tracing/filters: strloc should be unsigned short
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/29 Li Zefan <lizf@cn.fujitsu.com>:
> I forgot to update filter code accordingly in
> "tracing/events: change the type of __str_loc_item to unsigned short"
> (commt b0aae68cc5508f3c2fbf728988c954db4c8b8a53)
>
> It can cause system crash:
>
>  # echo 1 > tracing/events/irq/irq_handler_entry/enable
>  # echo 'name == eth0' > /mnt/tracing/events/irq/irq_handler_entry/filter
>
> [ Impact: fix system crash while filtering on __string() field ]
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_events_filter.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index a7430b1..a854eed 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -178,7 +178,7 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
>  static int filter_pred_strloc(struct filter_pred *pred, void *event,
>                              int val1, int val2)
>  {
> -       int str_loc = *(int *)(event + pred->offset);
> +       unsigned short str_loc = *(unsigned short *)(event + pred->offset);


Ouch, indeed :-)

I will apply this one and send it to Ingo, thanks!


>        char *addr = (char *)(event + str_loc);
>        int cmp, match;
>
> --
> 1.5.4.rc3
>
>
