Return-Path: <linux-kernel-owner+w=401wt.eu-S936348AbXFFXUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936348AbXFFXUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXFFXU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:20:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:3575 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbXFFXUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:20:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="236411452"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 6 Jun 2007 16:20:08 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <200706061528.44070.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061857420.2716@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706061857420.2716@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061620.10627.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 6, 2007 3:57 pm Justin Piszcz wrote:
> On Wed, 6 Jun 2007, Jesse Barnes wrote:
> > On Wednesday, June 6, 2007 3:26 pm Justin Piszcz wrote:
> >> Nope, I booted with only netconsole= options.  I have a lot of HW
> >> in the box and I guess the buffer is too small.  Not sure where to
> >> change it in the kernel.  Looking..
> >
> > It's called "kernel log buffer size" and it's in "General setup".
> >
> > Jesse
>
> Did the dmesg output get you what you needed?  Why the few KB
> difference?
>
> :)

Yeah, looked at your e820 and your MTRR settings and I think my patch is 
doing the right thing (i.e. trimming just the right amount of memory, 
leaving you with as much as possible).

The mem= approach though looks slightly off, but I haven't looked at 
x86_64's mem= handling to see why.  From a high level though, adjusting 
end_pfn is the right thing to do, since theoretically mem= could choose 
to make holes in your low memory and keep your high memory in the 
allocation pools (though it's not generally implemented this way).

Jesse
