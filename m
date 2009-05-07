Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbZEGJxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbZEGJxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZEGJxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:53:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55838 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZEGJxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:53:04 -0400
Date: Thu, 7 May 2009 03:53:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Sheng Yang <sheng@linux.intel.com>
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Message-ID: <20090507095302.GI8112@parisc-linux.org>
References: <20090507082841.GA31751@redhat.com> <200905071651.24970.sheng@linux.intel.com> <20090507092731.GH8112@parisc-linux.org> <200905071740.16190.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905071740.16190.sheng@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 05:40:15PM +0800, Sheng Yang wrote:
> It's indeed weird. Why the semantic of pci_enable_msix can be changed to 
> "enable msix, or tell me how many vector do you have"? You can simply call 
> pci_msix_table_size() to get what you want, also without any more work, no? I 
> can't understand...

Here's a good example.  Let's suppose you have a driver which supports
two different models of cards, one has 16 MSI-X interrupts, the other
has 10.  You can call pci_enable_msix() asking for 16 vectors.  If your
card is model A, you get 16 interrupts.  If your card is model B, it says
"you can have 10".

This is less work in the driver (since it must implement falling back to
a smaller number of interrupts *anyway*) than interrogating the card to
find out how many interrupts there are, then requesting the right number,
and still having the fallback path which is going to be less tested.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
