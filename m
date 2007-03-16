Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbXCPKOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbXCPKOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXCPKOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:14:52 -0400
Received: from smtp.nokia.com ([131.228.20.172]:58031 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899AbXCPKOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:14:50 -0400
Subject: Re: [PATCH 10/22 take 3] UBI: EBA unit
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, haver@vnet.ibm.com, hch@infradead.org,
       dwmw2@infradead.org, jwboyer@linux.vnet.ibm.com
In-Reply-To: <20070315110703.1c2dcce4.akpm@linux-foundation.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070314152024.1112.15655.sendpatchset@localhost.localdomain>
	 <20070315110703.1c2dcce4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 16 Mar 2007 12:14:03 +0200
Message-Id: <1174040043.31851.2.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Mar 2007 10:14:03.0866 (UTC) FILETIME=[D2E94BA0:01C767B3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 11:07 -0800, Andrew Morton wrote:
> > +	spin_lock(&ubi->eba.eba_tbl_lock);
> > +	ubi_assert(ubi->eba.eba_tbl[idx].recs);
> > +	leb_ver = ubi->eba.eba_tbl[idx].recs[lnum].leb_ver;
> > +	spin_unlock(&ubi->eba.eba_tbl_lock);
> > +
> > +	return leb_ver;
> > +}
> 
> I very much doubt that the locking in this function (and in the similar
> ones here) does anything useful.

Well, yes, these are integers.

> > +static inline void leb_unmap(struct ubi_info *ubi, int vol_id, int lnum)
> 
> The patch is full of nutty inlining.

Yeah, this file has too much of them.

> Suggestion: just remove all of it.  Then reintroduce inlining in only
> those places where a benefit is demonstrable.  Reduced code size according to
> /bin/size would be a suitable metric.

OK, thanks.

> > +	spin_unlock(&ubi->eba.eba_tbl_lock);
> > +
> > +	return pnum;
> > +}
> 
> Again, the locking seems pointless.

Thanks for comments, will be fixed.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

