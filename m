Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZEGXzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZEGXzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 19:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZEGXzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 19:55:14 -0400
Received: from ozlabs.org ([203.10.76.45]:56199 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbZEGXzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 19:55:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Date: Fri, 8 May 2009 09:25:00 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Sheng Yang <sheng@linux.intel.com>, Matthew Wilcox <matthew@wil.cx>,
       kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, Matthew Wilcox <willy@linux.intel.com>
References: <20090507082841.GA31751@redhat.com> <20090507095302.GI8112@parisc-linux.org> <200905071819.54426.sheng@linux.intel.com>
In-Reply-To: <200905071819.54426.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905080925.01398.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 07:49:53 pm Sheng Yang wrote:
> On Thursday 07 May 2009 17:53:02 Matthew Wilcox wrote:
> > Here's a good example.  Let's suppose you have a driver which supports
> > two different models of cards, one has 16 MSI-X interrupts, the other
> > has 10.  You can call pci_enable_msix() asking for 16 vectors.  If your
> > card is model A, you get 16 interrupts.  If your card is model B, it says
> > "you can have 10".

Sheng is absolutely right, that's a horrid API.

If it actually enabled that number and returned it, it might make sense (cf. 
write() returning less bytes than you give it).  But overloading the return 
value to save an explicit call is just ugly; it's not worth saving a few lines 
of code at cost of making all the drivers subtle and tricksy.

Fail with -ENOSPC or something.

Rusty.
