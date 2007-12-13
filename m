Return-Path: <linux-kernel-owner+w=401wt.eu-S933817AbXLMXI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbXLMXI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbXLMXIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:08:48 -0500
Received: from mx1.suse.de ([195.135.220.2]:48585 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXLMXIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:08:47 -0500
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Print taint info in more places.
From: Andi Kleen <andi@firstfloor.org>
References: <20071213224927.GA18639@redhat.com>
Date: Fri, 14 Dec 2007 00:08:46 +0100
In-Reply-To: <20071213224927.GA18639@redhat.com> (Dave Jones's message of "Thu\, 13 Dec 2007 17\:49\:27 -0500")
Message-ID: <p73y7byfb0h.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

>  #define WARN_ON(condition) ({						\
>  	int __ret_warn_on = !!(condition);				\
>  	if (unlikely(__ret_warn_on)) {					\
> -		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
> -			__LINE__, __FUNCTION__);			\
> +		printk(KERN_ERR "WARNING: at %s:%d %s() (%s)\n",	\
> +			 __FILE__, __LINE__, __FUNCTION__,		\
> +			 print_tainted());				\
>  		dump_stack();						\

Have you checked how this affects code size? It might be worth it 
now to do a out of line helper.

-Andi
