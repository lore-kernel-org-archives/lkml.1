Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZDMIXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZDMIXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 04:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZDMIX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 04:23:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45456 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZDMIX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 04:23:27 -0400
Date: Mon, 13 Apr 2009 10:26:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add MCE support to KVM
Message-ID: <20090413082603.GS14687@one.firstfloor.org>
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com> <49DE195D.1020303@redhat.com> <1239332455.6384.108.camel@yhuang-dev.sh.intel.com> <49E08762.1010206@redhat.com> <20090411121911.GR14687@one.firstfloor.org> <49E08C2F.4010003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E08C2F.4010003@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 03:25:19PM +0300, Avi Kivity wrote:
> Andi Kleen wrote:
> >>Right, but we can allocate the maximum number, no?  it's a fairly small 
> >>amount of memory.
> >>    
> >
> >There are 255 banks worst case which need upto 4 (in theory 5) MSRs each
> >
> >  
> 
> That's 8KB, which would normally not be allocated.  But I think we can 
> live with it.
> 
> Do we actually need to support 255 banks? 

Probably not. Current CPUs all have a single digit number.

e.g. 64 would be plenty for now.

> Or can we support a smaller 
> number transparently?

Not transparently. In theory software can hardcode that for cpu model X bank Y 
is available and does Z. Software doesn't have too, Intel provides a bank 
independent way to report errors too, but we don't know if everyone uses it.
Linux doesn't rely on bank numbers on Intel at least.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
