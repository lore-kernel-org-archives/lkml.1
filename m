Return-Path: <linux-kernel-owner+w=401wt.eu-S966019AbXCSPUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966019AbXCSPUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966017AbXCSPUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:20:46 -0400
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:42677 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966014AbXCSPUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:20:45 -0400
Message-ID: <45FEAA4B.4030302@grupopie.com>
Date: Mon, 19 Mar 2007 15:20:43 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH v3] Race between cat /proc/kallsyms and rmmod
References: <20070316114245.GA6817@localhost.sw.ru> <20070319143317.GB6805@localhost.sw.ru>
In-Reply-To: <20070319143317.GB6805@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Iterating code of /proc/kallsyms calls module_get_kallsym() which grabs
> and drops module_mutex internally and returns "struct module *",
> module is removed, aforementioned "struct module *" is used in non-trivial
> way.
> 
> Steps to reproduce:
> 
> 	modprobe/rmmod loop
> 	cat /proc/kallsyms >/dev/null loop
> 
> Copy all needed info under module_mutex.
> 
> NOTE: this patch keeps module_mutex static.

Yes, this patch fixes the "cat /proc/kallsyms" race without changing any 
"external" interfaces, so I think it should go into mainline in any case.

Acked-by: Paulo Marques <pmarques@grupopie.com>

-- 
Paulo Marques - www.grupopie.com

"All I ask is a chance to prove that money can't make me happy."
