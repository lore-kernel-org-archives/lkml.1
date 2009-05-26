Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZEZNMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZEZNMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZEZNMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:12:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35363 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZEZNML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:12:11 -0400
Date: Tue, 26 May 2009 15:18:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [7/16] POISON: Add basic support for poisoned pages in fault handler
Message-ID: <20090526131838.GE846@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407151004.2F5D21D0470@basil.firstfloor.org> <4A1BE6BE.90209@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1BE6BE.90209@hitachi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 09:55:26PM +0900, Hidehiro Kawai wrote:
> > +			print_bad_pte(vma, address, pte, NULL);
> > +			ret = VM_FAULT_OOM;
> > +		}
> >  		goto out;
> >  	}
> >  	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
> > @@ -2451,6 +2459,9 @@
> >  		/* Had to read the page from swap area: Major fault */
> >  		ret = VM_FAULT_MAJOR;
> >  		count_vm_event(PGMAJFAULT);
> > +	} else if (PagePoison(page)) {
> > +		ret = VM_FAULT_POISON;
> 
> delayacct_clear_flag(DELAYACCT_PF_SWAPIN) would be needed here.

Thanks for the review. Added.

Must have been a forward port error, I could swear that wasn't there
yet when I wrote this originally :)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
