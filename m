Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYIVWm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYIVWm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYIVWmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:42:50 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41063 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYIVWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:42:49 -0400
Date: Mon, 22 Sep 2008 16:42:32 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       kristen.c.accardi@intel.com, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v2 02/13] PCI: prevent duplicate slot names
Message-ID: <20080922224232.GB27204@parisc-linux.org>
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100012.29542.62582.stgit@bob.kio> <20080909130716.GV2772@parisc-linux.org> <20080922213845.GD3035@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922213845.GD3035@ldl.fc.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 03:38:45PM -0600, Alex Chiang wrote:
> As Rolf Eike Beer pointed out, a failed krealloc() will leak the
> old version of new_name, so I did this instead:
> 
> 			kfree(new_name);
> 			new_name = kmalloc(len, GFP_KERNEL);
> 
> This is better than krealloc() in several ways:
> 
> 	1. we avoid the unneeded memcpy that krealloc() does for
> 	us. we don't need it because we're going to sprintf over
> 	it anyway.
> 
> 	2. the explicit kfree(new_name) means we won't leak
> 	anything.

Agreed.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
