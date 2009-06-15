Return-Path: <linux-kernel-owner+w=401wt.eu-S1763653AbZFOQAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763653AbZFOQAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761639AbZFOP77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:59:59 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:1289 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762616AbZFOP76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:59:58 -0400
Message-ID: <4A366FF7.2010206@caviumnetworks.com>
Date: Mon, 15 Jun 2009 08:59:51 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Wu Zhangjin <wuzhangjin@gmail.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wang Liming <liming.wang@windriver.com>, Wu Zhangjin <wuzj@lemote.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3] filter local function prefixed by $L
References: <cover.1244994151.git.wuzj@lemote.com> <d0983eb71d7517d0e536352f3288e995abbb0e07.1244994151.git.wuzj@lemote.com>
In-Reply-To: <d0983eb71d7517d0e536352f3288e995abbb0e07.1244994151.git.wuzj@lemote.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2009 15:59:51.0485 (UTC) FILETIME=[510336D0:01C9EDD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzj@lemote.com>
> 
> this patch fixed the warning as following:
> 
> mipsel-linux-gnu-objcopy: 'fs/proc/.tmp_gl_devices.o': No such file
> mipsel-linux-gnu-ld: fs/proc/.tmp_gl_devices.o: No such file: No such
> file or directory
> rm: cannot remove `fs/proc/.tmp_gl_devices.o': No such file or directory
> rm: cannot remove `fs/proc/.tmp_mx_devices.o': No such file or directory
> 
> the real reason of above warning is that the $Lxx local functions will
> be treated as global symbols, so, should be filtered.
> 
> Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
> ---
>  scripts/recordmcount.pl |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 533d3bf..542cb04 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -343,6 +343,10 @@ sub update_funcs
>  	if (!$use_locals) {
>  	    return;
>  	}
> +	# filter $LXXX tags
> +	if ("$ref_func" =~ m/\$L/) {
> +		return;
> +	}

Certainly this is true for mips.  I doubt it is for all architectures 
targed by Linux.

David Daney


