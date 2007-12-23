Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbXLWUXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbXLWUXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbXLWUXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:23:24 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:63664 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXLWUXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:23:23 -0500
Message-ID: <fa686aa40712231223j18b83ff6ne5ade95a88ebbc79@mail.gmail.com>
Date: Sun, 23 Dec 2007 13:23:22 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH] fat: Editions to support fat_fallocate()
Cc: "Steven Cavanagh" <steven.cavanagh@secretlab.ca>,
       linux-kernel@vger.kernel.org
In-Reply-To: <87tzm91u98.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071222210958.9351.35913.stgit@jpe-laptop>
	 <fa686aa40712221418m601d3ffrd5b9158104712078@mail.gmail.com>
	 <87tzm91u98.fsf@duaron.myhome.or.jp>
X-Google-Sender-Auth: eb0621839f7b91ee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/07, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
> "Grant Likely" <grant.likely@secretlab.ca> writes:
> >
> > However, digging further, when FALLOC_FL_KEEP_SIZE is set, I don't
> > think fat_cont_expand() has the behaviour that we want to implement.
> > When that flag is set, I think we simply want to add clusters
> > associated with the file to the FAT.  We don't want to clear them or
> > map them into the page cache yet (that should be done when the
> > filesize is increased for real).
> >
> > I believe a call to fat_allocate_clusters() is all that is needed in
> > this case.  Hirofumi, please correct me if I'm wrong.
>
> Right. And we need to care the limitation on FAT specification (compatibility).

I not sure I fully understand what you mean.  Can you please
elaborate?  Are you referring to whether on not it will break other
FAT implementations if a file has more clusters allocated than it
needs?  If so, how do we decide whether or not it is acceptable?

Thanks,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
