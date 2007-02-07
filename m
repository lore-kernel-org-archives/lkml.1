Return-Path: <linux-kernel-owner+w=401wt.eu-S1422805AbXBGX50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422805AbXBGX50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 18:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422821AbXBGX50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 18:57:26 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:48444 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422805AbXBGX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 18:57:25 -0500
Message-ID: <45CA6711.40502@student.ltu.se>
Date: Thu, 08 Feb 2007 00:56:01 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Josh Triplett <josh@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] rcutorture: Remove redundant assignment to cur_ops
 in for loop
References: <45CA206C.2080205@kernel.org> <45CA212A.7000504@kernel.org>
In-Reply-To: <45CA212A.7000504@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett wrote:
> The for loop in rcutorture_init uses the condition
> cur_ops = torture_ops[i], cur_ops
> but then makes the same assignment to cur_ops inside the loop.  Remove the
> redundant assignment inside the loop, and remove now-unnecessary braces.
>
> Signed-off-by: Josh Triplett <josh@kernel.org>
> ---
>  kernel/rcutorture.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 0c7bf0c..7258bcb 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -875,12 +875,9 @@ rcu_torture_init(void)
>  
>  	/* Process args and tell the world that the torturer is on the job. */
>  
> -	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++) {
> -		cur_ops = torture_ops[i];
> -		if (strcmp(torture_type, cur_ops->name) == 0) {
> +	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++)
>   
May be tired right now, but wouldn't it be more logical with:

for (i = 0; cur_ops = torture_ops[i], i++)

Right now it seems to have two conditions for cur_ops.


Just my 2cent
Richard Knutsson


