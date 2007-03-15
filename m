Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXCOWZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXCOWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXCOWZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:25:56 -0400
Received: from xenotime.net ([66.160.160.81]:50551 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932274AbXCOWZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:25:53 -0400
Date: Thu, 15 Mar 2007 14:24:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>, linux-kernel@vger.kernel.org,
       haver@vnet.ibm.com, hch@infradead.org, dwmw2@infradead.org,
       jwboyer@linux.vnet.ibm.com
Subject: Re: [PATCH 10/22 take 3] UBI: EBA unit
Message-Id: <20070315142410.371adbf0.rdunlap@xenotime.net>
In-Reply-To: <20070315110703.1c2dcce4.akpm@linux-foundation.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	<20070314152024.1112.15655.sendpatchset@localhost.localdomain>
	<20070315110703.1c2dcce4.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 11:07:03 -0800 Andrew Morton wrote:

> 
> There's way too much code here to expect it to get decently reviewed, alas.

Yes.

/me repeats wish that Not Everything Should Be Sent to lkml.  :(

> > On Wed, 14 Mar 2007 17:20:24 +0200 Artem Bityutskiy <dedekind@infradead.org> wrote:
> >
> > ...
> >
> > +/**
> > + * leb_get_ver - get logical eraseblock version.
> > + *
> > + * @ubi: the UBI device description object
> > + * @vol_id: the volume ID
> > + * @lnum: the logical eraseblock number
> > + *
> > + * The logical eraseblock has to be locked. Note, all this leb_ver stuff is
> > + * obsolete and will be removed eventually. FIXME: to be removed together with
> > + * leb_ver support.
> > + */

Please use kernel-doc syntax and test it.  Using and testing it
are really easy to do.  It's just a simple language.  Don't make
(even trivial) problems for others to clean up...

Documentation/kernel-doc-nano-HOWTO.txt

Above:  no "blank" line between the function name and its parameters.

> > +static inline int leb_get_ver(struct ubi_info *ubi, int vol_id, int lnum)
> > +{
> > +	int idx, leb_ver;
> > +
> > +	idx = vol_id2idx(ubi, vol_id);
> > +
> > +	spin_lock(&ubi->eba.eba_tbl_lock);
> > +	ubi_assert(ubi->eba.eba_tbl[idx].recs);
> > +	leb_ver = ubi->eba.eba_tbl[idx].recs[lnum].leb_ver;
> > +	spin_unlock(&ubi->eba.eba_tbl_lock);
> > +
> > +	return leb_ver;
> > +}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
