Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYFDEwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYFDEwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYFDEv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:51:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:24774 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYFDEvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=svzc+wJnizs6I+HPe+FC+a5zackFdUnvaFfApK7yKmpEKDiV6LZEmjLyylgKtBZBW3aYjmOoiGPRO+hr8UUUI+Y9420zgyOgoPBwsBt6WBzwnZmWvQgUZq9ZkrQ1His7w3a7K10y/Z6MKs3Qt/110JdlJIhc8gp3J12vR/T+wBU=
Message-ID: <86802c440806032151l5faedf22xe0107d4c99c55c21@mail.gmail.com>
Date: Tue, 3 Jun 2008 21:51:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Glauber Costa" <gcosta@redhat.com>
Subject: Re: [PATCH] Make x86 latest boot with non-discontig boxes
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1212552507-15134-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212552507-15134-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 9:08 PM, Glauber Costa <gcosta@redhat.com> wrote:
> Commit 0596152388e234efebce464355186ad9e16c8cb6
> broke my box, since it removes completely the call to
> memory_present() at e820 setup.
>
> It seems to be really not needed with discontig memory,
> but with flat and sparse, I get an early crash. The proposed patch
> moves the call memory_present() to setup_memory, the one
> present in setup_32.c.
>
> Signed-off-by: Glauber Costa <gcosta@redhat.com>
> CC: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>  arch/x86/kernel/setup_32.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
> index 2901042..841eb2f 100644
> --- a/arch/x86/kernel/setup_32.c
> +++ b/arch/x86/kernel/setup_32.c
> @@ -388,6 +388,8 @@ static unsigned long __init setup_memory(void)
>  #ifdef CONFIG_FLATMEM
>        max_mapnr = num_physpages;
>  #endif
> +       memory_present(0, 0, max_pfn);
> +
>        printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
>                        pages_to_mb(max_low_pfn));
>
> --
thanks

http://lkml.org/lkml/2008/6/3/229
[PATCH] x86: change propagate_e820_map back to find_max_pfn -32bit - fix

already address that.

YH
