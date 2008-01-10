Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbYAJQkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbYAJQkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbYAJQkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:40:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:28665 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbYAJQkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:40:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cJg6IIhErIk1LW0uCUhXzR7HzVIKOTJ1iFRx6+BVATrsXCqP3VQ3tsI7EYMaE8/28DuoynPjrV3LWlXoS+nxjcAj1Wd013Co3XYmEw+0VnyE3GM2eQYwLDm8OgK3XLyu2Mhcq8KfBhZL4CC+o9FVJMQMxqA/RvYabqcyWFbvKN4=
Message-ID: <4df4ef0c0801100840uf84fef6g80e456fc5681193@mail.gmail.com>
Date: Thu, 10 Jan 2008 19:40:41 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
Cc: "Jakob Oestergaard" <jakob@unthought.net>, Valdis.Kletnieks@vt.edu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080110110757.09ec494a@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199728459.26463.11.camel@codedot>
	 <20080109170633.292644dc@cuia.boston.redhat.com>
	 <20080109223340.GH25527@unthought.net>
	 <20080109184141.287189b8@bree.surriel.com>
	 <4df4ef0c0801091603y2bf507e1q2b99971c6028d1f3@mail.gmail.com>
	 <20080110085120.GK25527@unthought.net>
	 <4df4ef0c0801100253m6c08e4a3t917959c030533f80@mail.gmail.com>
	 <20080110104543.398baf5c@bree.surriel.com>
	 <4df4ef0c0801100756v2a536cc5xa80d9d1cfdae073a@mail.gmail.com>
	 <20080110110757.09ec494a@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/10, Rik van Riel <riel@redhat.com>:
> On Thu, 10 Jan 2008 18:56:07 +0300
> "Anton Salikhmetov" <salikhmetov@gmail.com> wrote:
>
> > However, I don't see how they will work if there has been
> > something like a sync(2) done after the mmap'd region is
> > modified and the msync call.  When the inode is written out
> > as part of the sync process, I_DIRTY_PAGES will be cleared,
> > thus causing a miss in this code.
> >
> > The I_DIRTY_PAGES check here is good, but I think that there
> > needs to be some code elsewhere too, to catch the case where
> > I_DIRTY_PAGES is being cleared, but the time fields still need
> > to be updated.
>
> Agreed. The mtime and ctime should probably also be updated
> when I_DIRTY_PAGES is cleared.
>
> The alternative would be to remember that the inode had been
> dirty in the past, and have the mtime and ctime updated on
> msync or close - which would be more complex.

Adding the new flag (AS_MCTIME) has been already suggested by Peter
Staubach in his first solution for this bug. Now I understand that the
AS_MCTIME flag is required for fixing the bug.

>
> --
> All rights reversed.
>
