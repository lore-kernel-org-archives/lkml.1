Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYJ0Hps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYJ0Hps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYJ0Hpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:45:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33387 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYJ0Hpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:45:40 -0400
Date: Mon, 27 Oct 2008 01:45:23 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Yu Zhao <yu.zhao@uniscape.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] pci: Fixing drivers/pci/search.c compilation warning.
Message-ID: <20081027074523.GA26094@parisc-linux.org>
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com> <20080928163211.GR27204@parisc-linux.org> <20081021011308.GA3889@parisc-linux.org> <490467CD.3000402@uniscape.net> <20081026183412.GX26094@parisc-linux.org> <49053313.9080706@intel.com> <20081027070745.GY26094@parisc-linux.org> <49056A2F.6030206@intel.com> <20081027072137.GZ26094@parisc-linux.org> <49056EF6.3000904@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49056EF6.3000904@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 03:34:14PM +0800, Zhao, Yu wrote:
> >Erm, no, the 'dev' cannot be destroyed because the caller has a refcount
> >on it.  The physical device backing it might have gone away.  The dev
> 
> Why does the caller have a reference count? I don't see we increase the 
> reference count after the 'dev' is returned by following in 
> pci_get_dev_by_id():
> 
>         dev = bus_find_device(&pci_bus_type, dev_start, (void *)id,
>                               match_pci_dev_by_id);
> 
> And this 'dev' becomes the 'from' in the next loop, but it may be 
> destroyed before the 'pci_dev_get(from)', isn't it?

Either you've gone back to talking about pci_find_device() [which, yes, is
vulnerable to race conditions, we know that, it's not interesting to talk
about it], or you're refusing to take it on faith that pci_get_dev_by_id()
returns a device with an increased refcount.  And if you don't believe
that is true, please follow the code in bus_find_device() to prove it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
