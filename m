Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZLRPd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZLRPd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZLRPd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:33:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbZLRPdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:33:25 -0500
Message-ID: <4B2BA087.9030102@redhat.com>
Date: Fri, 18 Dec 2009 10:32:23 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH x86/urgent] x86: Fix objdump version check in chkobjdump.awk
 for different formats.
References: <4B2ACC11.3020209@zytor.com> <20091218153442.16571.41882.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091218153442.16571.41882.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Different version of objdump says its version in different way;
> 
> GNU objdump 2.16.1
> 
> or
> 
> GNU objdump version 2.19.51.0.14-1.fc11 20090722
> 
> This patch uses the first argument which starts with a number
> as version string.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Suggested-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/tools/chkobjdump.awk |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
> index 5bbb5a3..250dc79 100644
> --- a/arch/x86/tools/chkobjdump.awk
> +++ b/arch/x86/tools/chkobjdump.awk
> @@ -8,14 +8,24 @@ BEGIN {
>  	od_sver = 19;
>  }
>  
> -/^GNU/ {
> -	split($3, ver, ".");
> +/^GNU objdump/ {
> +	verstr = ""
> +	for (i = 3; i <= NF; i++)
> +		if (match($(i), "^[0-9]")) {
> +			verstr = $(i++);
                                   ^^^^oops, it's not needed!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

