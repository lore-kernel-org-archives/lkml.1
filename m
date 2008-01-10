Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbYAJQIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbYAJQIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbYAJQIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:08:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759361AbYAJQIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:08:34 -0500
Date: Thu, 10 Jan 2008 11:07:57 -0500
From: Rik van Riel <riel@redhat.com>
To: "Anton Salikhmetov" <salikhmetov@gmail.com>
Cc: "Jakob Oestergaard" <jakob@unthought.net>, Valdis.Kletnieks@vt.edu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in
 msync()
Message-ID: <20080110110757.09ec494a@bree.surriel.com>
In-Reply-To: <4df4ef0c0801100756v2a536cc5xa80d9d1cfdae073a@mail.gmail.com>
References: <1199728459.26463.11.camel@codedot>
	<20080109155015.4d2d4c1d@cuia.boston.redhat.com>
	<26932.1199912777@turing-police.cc.vt.edu>
	<20080109170633.292644dc@cuia.boston.redhat.com>
	<20080109223340.GH25527@unthought.net>
	<20080109184141.287189b8@bree.surriel.com>
	<4df4ef0c0801091603y2bf507e1q2b99971c6028d1f3@mail.gmail.com>
	<20080110085120.GK25527@unthought.net>
	<4df4ef0c0801100253m6c08e4a3t917959c030533f80@mail.gmail.com>
	<20080110104543.398baf5c@bree.surriel.com>
	<4df4ef0c0801100756v2a536cc5xa80d9d1cfdae073a@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 18:56:07 +0300
"Anton Salikhmetov" <salikhmetov@gmail.com> wrote:

> However, I don't see how they will work if there has been
> something like a sync(2) done after the mmap'd region is
> modified and the msync call.  When the inode is written out
> as part of the sync process, I_DIRTY_PAGES will be cleared,
> thus causing a miss in this code.
> 
> The I_DIRTY_PAGES check here is good, but I think that there
> needs to be some code elsewhere too, to catch the case where
> I_DIRTY_PAGES is being cleared, but the time fields still need
> to be updated.

Agreed. The mtime and ctime should probably also be updated
when I_DIRTY_PAGES is cleared.

The alternative would be to remember that the inode had been
dirty in the past, and have the mtime and ctime updated on
msync or close - which would be more complex.

-- 
All rights reversed.
