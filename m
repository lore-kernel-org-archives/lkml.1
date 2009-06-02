Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbZFBNdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbZFBNdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZFBNdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:33:32 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:42121
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754372AbZFBNdc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:33:32 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432R98dR1805M179dR873fnzz1202hzzz32i6bh17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KKM5NL-02-FS5-01
Date: Tue, 2 Jun 2009 15:33:21 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] dma-debug: add debugfs file for driver filter
Message-ID: <20090602133321.GA2231@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com> <1243523971-12681-3-git-send-email-joerg.roedel@amd.com> <20090601150418.79dfd250.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090601150418.79dfd250.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Jun 2009 13:33:22.0096 (UTC) FILETIME=[B2C22300:01C9E386]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 03:04:18PM -0700, Andrew Morton wrote:
> On Thu, 28 May 2009 17:19:29 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +	/*
> > +	 * We can't copy from userspace directly. Access to
> > +	 * current_driver_name is protected with a write_lock with irqs
> > +	 * disabled. Since copy_from_user can fault and may sleep we
> > +	 * need to copy to temporary buffer first
> > +	 */
> > +	len = min(count, len);
> > +	if (copy_from_user(buf, userbuf, len))
> > +		return -EFAULT;
> > +
> > +	buf[NAME_MAX_LEN - 1] = 0;
> 
> Might be able to use strncpy_from_user() here.
>

Hmm, no, not in this place because I can't be sure that userspace passes
a NULL-terminated string. So setting a character in the resulting string
to \0 is always required. This eliminates the benefit of
strncpy_from_user() here.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

