Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZHLUxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZHLUxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZHLUxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:53:42 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:18600 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345AbZHLUxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:53:42 -0400
X-Trace: 245750529/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.104.135/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.104.135
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArUEAAPJgkpPRWiH/2dsb2JhbACBUtI5hBkF
X-IronPort-AV: E=Sophos;i="4.43,370,1246834800"; 
   d="scan'208";a="245750529"
Date: Wed, 12 Aug 2009 21:53:25 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Bill Speirs <bill.speirs@gmail.com>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: vma_merge issue
In-Reply-To: <Pine.LNX.4.64.0908122038360.18426@sister.anvils>
Message-ID: <Pine.LNX.4.64.0908122143020.20776@sister.anvils>
References: <a1b36c3a0908101347t796dedbat2ecb0535c32f325b@mail.gmail.com> 
 <Pine.LNX.4.64.0908121841550.14314@sister.anvils>
 <a1b36c3a0908121204q1b59df1fk86afec9d05ec16dc@mail.gmail.com>
 <Pine.LNX.4.64.0908122038360.18426@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, Hugh Dickins wrote:
> 
> Don't use anonymous memory, have a 1GB sparse file to back this,
> and mmap it MAP_SHARED, then you won't get charged for RAM+swap.

A "refinement" to that suggestion is to put the file on tmpfs:
you will then get charged for RAM+swap as you use it, but you can
use madvise MADV_REMOVE to unmap pages, punching holes in the file,
freeing up those charges.  A little baroque, but I think it does
amount to a way of doing exactly what you wanted in the first place.

(Note: we do insist on PROT_WRITE access at the time of MADV_REMOVE:
I've even a feeling it was me who insisted on that.)

Hugh
