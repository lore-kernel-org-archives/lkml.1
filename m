Return-Path: <linux-kernel-owner+w=401wt.eu-S1751419AbZIKE5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbZIKE5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 00:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZIKE5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 00:57:35 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:45243 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZIKE5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 00:57:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GUo05IDPo0SqFL4jhXGDwWNDOX395+rVwwIX3Rs1zjgqvYq3Lp4KXZt/mgwgceXg4x
         nWJA3l14BkWpvIwcEpCahN1KGg1Ahv8rJPdgLj1XPwIVUKtkwEDoNKtIIBQIiZcR5+wM
         g8Gi452MWGNvZ4vKZdVbDNg2yH+0vRZLKRuLQ=
Date: Thu, 10 Sep 2009 21:57:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Linux Input <linux-input@vger.kernel.org>,
       LKLM <linux-kernel@vger.kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH -next] Input: i8042 - Fix pagefault caused by
	i8042_dmi_laptop_table
Message-ID: <20090911045731.GA23210@core.coreip.homeip.net>
References: <4AA9C0F1.6060708@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA9C0F1.6060708@np.css.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin,

On Fri, Sep 11, 2009 at 12:16:01PM +0900, Jin Dongming wrote:
> (This patch fixes bug of commit 1c49cd1bbb6e41e97079d389e86063ba5de825ed
>  titled "Input: i8042 - bypass AUX IRQ delivery test on laptops")
> 
> When dmi_platform_init is called, the table i8042_dmi_laptop_table[] will
> be checked. Because the end of this table is not "NULL", dmi_check_system
> will lead to pagefault and oops will be happened.
> 
> In fact I got following oops on boot:
> Call Trace:
>   [<ffffffff813f86b8>] panic+0x7a/0x131
>   [<ffffffff8105b29b>] ? exit_ptrace+0x94/0x114
>   [<ffffffff81054acc>] do_exit+0x7a/0x695
>   [<ffffffff813fbaec>] oops_end+0xb9/0xc1
>   [<ffffffff81034037>] no_context+0x1f6/0x205
>   [<ffffffff81034212>] __bad_area_nosemaphore+0x1cc/0x1f2
>   [<ffffffff811f1739>] ? string+0x40/0x9f
>   [<ffffffff811f20cf>] ? vsnprintf+0x8b/0x426
>   [<ffffffff813fac0a>] ?_spin_unlock_irqrestore+0x29/0x41
>   [<ffffffff8103424b>] bad_area_nosemaphore+0x13/0x15
>   [<ffffffff813fcf9d>] do_page_fault+0x154/0x2a5
>   [<ffffffff813faef5>] page_fault+0x25/0x30
>   [<ffffffff81335895>] ? dmi_check_system+0x30/0x4b
>   [<ffffffff816eee5f>] i8042_init+0x2ca/0x3c1
>   [<ffffffff816ee5eb>] ? uhci_hcd_init+0x88/0xc0
>   [<ffffffff816eeb95>] ? i8042_init+0x0/0x3c1
>   [<ffffffff8100a069>] do_one_initcall+0x5e/0x15e
>   [<ffffffff816be167>] kernel_init+0x170/0x1ca
>   [<ffffffff81012c5a>] child_rip+0xa/0x20
>   [<ffffffff810125bd>] ? restore_args+0x0/0x30
>   [<ffffffff81bbdff7>] ? kernel_init+0x0/0x1ca
>   [<ffffffff81012c50>] ? child_rip+0x0/0x20
> 
> I confirmed this patch fix this problem.
> 

Thank you for the patch, I will ford it into the original change so that
we don't crash the box in case someone will be bisecting...

-- 
Dmitry
