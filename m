Return-Path: <linux-kernel-owner+w=401wt.eu-S1161257AbXCNMzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161257AbXCNMzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161258AbXCNMzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:55:13 -0400
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:54326 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1161257AbXCNMzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:55:11 -0400
Message-ID: <45F7F0AD.9010603@grupopie.com>
Date: Wed, 14 Mar 2007 12:55:09 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Race between cat /proc/kallsyms and rmmod
References: <20070314111328.GA6807@localhost.sw.ru>
In-Reply-To: <20070314111328.GA6807@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Iterating code of /proc/kallsyms calls module_get_kallsym() which grabs
> and drops module_mutex internally and returns "struct module *",
> module is removed, aforementioned "struct module *" is used in non-trivial
> way.
> So, grab module_mutex for entire operation like /proc/modules does.

I would still prefer the other solution to avoid exposing "module_mutex" 
outside of module.c like this :(

I'll try to send in a patch today for review.

-- 
Paulo Marques - www.grupopie.com

"As far as we know, our computer has never had an undetected error."
Weisert
