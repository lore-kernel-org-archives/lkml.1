Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbYBWJGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbYBWJGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934170AbYBWJGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:06:19 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:58005 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933915AbYBWJGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:06:15 -0500
Date: Sat, 23 Feb 2008 02:06:13 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: Accessor macros vs reference counting
Message-ID: <20080223090613.GJ16995@parisc-linux.org>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com> <12037544671847-git-send-email-xiyou.wangcong@gmail.com> <1203754478165-git-send-email-xiyou.wangcong@gmail.com> <1203754488669-git-send-email-xiyou.wangcong@gmail.com> <12037544991876-git-send-email-xiyou.wangcong@gmail.com> <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 04:14:08PM +0800, WANG Cong wrote:
> Use get_personality() macro instead of explicit reference
> for parisc code.
> -	if (personality(current->personality) == PER_LINUX32
> +	if (personality(get_personality()) == PER_LINUX32

Hm.  We have an interesting clash of conventions here.

On the one hand, we have the java-style accessor convention.
get_personality()/set_personality().

On the other hand, we have reference counting.  get_cpu()/put_cpu().

When I first saw this patch, I assumed the latter (and went looking for
the missing put_), but _personality is of the former style.  I have one
suggestion (that nobody is going to like), which is that we suffix
reference-counting functions with _ref, ie:

get_cpu_ref()
put_cpu_ref()
pci_get_device_ref()
pci_put_device_ref()
pci_dev_get_ref()
pci_dev_put_ref()

(PCI is actually a good example here; it has "get" referring both to
refcounting and to accessors)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
