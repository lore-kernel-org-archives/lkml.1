Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYLIAa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYLIAa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 19:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYLIAaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 19:30:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbYLIAaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 19:30:46 -0500
Date: Mon, 8 Dec 2008 19:30:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] checkpatch: struct file_operations should
	normally be const
Message-ID: <20081209003043.GB12482@goodmis.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org> <1228674650-24392-12-git-send-email-apw@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228674650-24392-12-git-send-email-apw@shadowen.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 06:30:48PM +0000, Andy Whitcroft wrote:
> From: Andy Whitcroft <apw@canonical.com>
> 
> In the general use case struct file_operations should be a const object.
> Check for and warn where it is not.  As suggested by Steven and Ingo.

Andy,

Thanks for doing this!

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  scripts/checkpatch.pl |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index c39ce0b..94371f6 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2509,6 +2509,11 @@ sub process {
>  		if ($line =~ /^.\s*__initcall\s*\(/) {
>  			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
>  		}
> +# check for struct file_operations, ensure they are const.
> +		if ($line =~ /\bstruct\s+file_operations\b/ &&
> +		    $line !~ /\bconst\b/) {
> +			WARN("struct file_operations should normally be const\n" . $herecurr);
> +		}
>  
>  # use of NR_CPUS is usually wrong
>  # ignore definitions of NR_CPUS and usage to define arrays as likely right
> -- 
> 1.6.0.4.911.gc990
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
