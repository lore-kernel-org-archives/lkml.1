Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbZC1VtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbZC1VtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZC1VtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:49:06 -0400
Received: from 8bytes.org ([88.198.83.132]:33110 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbZC1VtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:49:05 -0400
Date: Sat, 28 Mar 2009 22:49:00 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Support for GB pages in KVM
Message-ID: <20090328214900.GE31080@8bytes.org>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <20090328214008.GB4694@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090328214008.GB4694@amt.cnet>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 06:40:08PM -0300, Marcelo Tosatti wrote:
> On Fri, Mar 27, 2009 at 03:31:52PM +0100, Joerg Roedel wrote:
> > Hi,
> > 
> > this patchset extends the KVM MMU implementation to support 1GB pages as
> > supported by AMD family 16 processors. These patches enable support for
> > 1 GB pages with Nested Paging. Support for these pages in the shadow
> > paging code was also developed but does not run stable yet. The patch
> > for shadow-paging support is not included in this series and will be
> > sent out seperatly.
> 
> Looks generally sane. I'm not sure its even worthwhile to support
> GBpages with softmmu, because the chance of finding an area without
> shadowed (write protected) pages is much smaller than with 2MB pages.

Thanks for your review.

The idea behind GB pages in softmmu code was to provide GB pages to the
guest even if hardware does not support it. This would work better with
live migration (Only case where we wouldn't have gbpages then would be
vmx with ept enabled).

> Have any numbers to share?

No numbers I fully trust by now. I measured a 32% improvement in
kernbench using nested pages backed with gb pages. I will do some more
measurements and share some more solid numbers.

Joerg

