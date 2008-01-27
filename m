Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYA0Iki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYA0Iki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 03:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYA0Ik3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 03:40:29 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:56321
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYA0Ik3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 03:40:29 -0500
Message-ID: <479C4379.8090005@qumranet.com>
Date: Sun, 27 Jan 2008 10:40:25 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 4/8] X86: export information about NPT to
 generic x86 code
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-5-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1201294393-22613-5-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> The generic x86 code has to know if the specific implementation uses Nested
> Paging. In the generic code Nested Paging is called Hardware Assisted Paging
> (HAP) to avoid confusion with (future) HAP implementations of other vendors.
> This patch exports the availability of HAP to the generic x86 code.
>
>  	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
> +
> +	bool (*hap_enabled)(void);
>  };
>  
>   

Since the value doesn't change during the lifetime of the VM, it can be 
a data field instead of a function.  Or, if we find that npt/ept is 
always a win, a static field in mmu.c.

-- 
error compiling committee.c: too many arguments to function

