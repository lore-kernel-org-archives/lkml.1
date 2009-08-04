Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZHDJwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZHDJwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932689AbZHDJwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:52:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39593 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZHDJwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:52:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 4 Aug 2009 18:50:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: get_user_pages() on an mmap()ed file allowed? What to do if 0 <
  get_user_pages(..., nr_pages, ...) < nr_pages?
Message-Id: <20090804185058.09f79b37.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <c384c5ea0908040157g222f5408o52dd10f02da5a07d@mail.gmail.com>
References: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com>
	<Pine.LNX.4.64.0908031724200.2296@sister.anvils>
	<c384c5ea0908040157g222f5408o52dd10f02da5a07d@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009 10:57:33 +0200
Leon Woestenberg <leon.woestenberg@gmail.com> wrote:


> >> - what should a driver do when get_user_pages() returns less pages
> >> than requested?
> >
> > Probably put_page the pages gotten then report the surprise;
> > perhaps, before putting the pages gotten, try get_user_pages
> > on the next alone, to see what error code is returned for that.
> >
> > Unless it's happy to work with fewer pages than requested,
> > in which case work with them and ignore the surprise.
> >
> I expect a certain amount of data to be DMA'd from the PCI device to
> the file mmap, so I'ld rather map the complete file before I start
> DMA.
> 
I wonder.... If your device does DMA from-PCI-to-user, then,

  rc = get_user_pages(current, current->mm, start & PAGE_MASK,
nr_pages, 0 /* do not write*/, 1 /* do force */, pages, NULL);

This is *write* access. isn't it ? (contents of pages got by this call
will be overwritten by DMA ?) 

About (rc != nr_pages) case, I doubt there are difference between
mmap region (or size of file) and [start, start+count) passed to you device.

Thanks,
-Kame


