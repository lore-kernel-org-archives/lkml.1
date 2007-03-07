Return-Path: <linux-kernel-owner+w=401wt.eu-S1030622AbXCGOi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622AbXCGOi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030628AbXCGOi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:38:29 -0500
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:34832 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1030622AbXCGOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:38:28 -0500
Message-ID: <45EECE60.4010808@grupopie.com>
Date: Wed, 07 Mar 2007 14:38:24 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Robert Peterson <rpeterso@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc1] Extend print_symbol capability TRY #3
References: <45EDCE67.3010902@redhat.com>
In-Reply-To: <45EDCE67.3010902@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Peterson wrote:
>[...]
> @@ -47,6 +52,11 @@ static inline const char *kallsyms_lookup(unsigned 
> long addr,
>     return NULL;
> }
> 
> +static inline void sprint_symbol(char *buffer, unsigned long addr)
> +{
> +    return;
> +}

I'm really sorry for not replying sooner (I've been really busy), but 
this function still doesn't seem right.

If someone does something like:

> void my_function(unsigned long addr)
> {
> 	char buffer[KSYM_SYMBOL_LEN];
> 
> 	sprint_symbol(buffer, addr);
> 	...
> 	// use buffer to print somewhere
> 	...
> }

which seems like a perfectly natural thing to do, it might just oops the 
kernel if CONFIG_KALLSYMS is not set, because the buffer will be left 
uninitialized.

That is why I suggested to change it to something like "*buffer = '\0'" 
instead.

The really nice solution IMHO, would be to remove the print_symbol and 
sprint_symbol functions from the the "#ifdef CONFIG_KALLSYMS" and just 
let them be available even in a not CONFIG_KALLSYMS kernel.

Since kallsyms_lookup is already #ifdef'ed to something sane, 
sprint_symbol will just print out the symbol address in that case, but 
it is better than not printing anything at all.

-- 
Paulo Marques - www.grupopie.com

"Very funny Scotty. Now beam up my clothes."
