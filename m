Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbYBARjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbYBARjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYBARjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:39:25 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:32434 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYBARjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:39:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fo0kx7Y89IwKGoTn0USNDZ5lPg/4fvDk8aFij3kjt7GF1uMJaMPMsK0Fh/p2OM4U9jB8QFTr6wR7eaMCSdqqw/kk6GzmN695+N+dmWOEp+NZRZpIbakoZrQGAyqzkk0/oRYTZ96CIM1M8TT7CguAy6bgroK0OFXs5EwVRMvhkTA=
Message-ID: <3fd7d7a70802010939q67770628r47ca8a23fb26ca1d@mail.gmail.com>
Date: Sat, 2 Feb 2008 02:39:23 +0900
From: "Kenichi Okuyama" <kenichi.okuyama@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] NULL pointer check for vma->vm_mm
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080201021917.5db3448d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3fd7d7a70801312339p2a142096p83ed286c81379728@mail.gmail.com>
	 <20080131235544.346b938a.akpm@linux-foundation.org>
	 <3fd7d7a70802010024q22b4d179mf56e6d4b60e4f574@mail.gmail.com>
	 <20080201021917.5db3448d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew,
Sorry that it took very long before I could reply.

2008/2/1, Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 1 Feb 2008 17:24:17 +0900 "Kenichi Okuyama" <kenichi.okuyama@gmail.com> wrote:
>
> > First of all, thank you for looking at the patch.
> >
> > I do agree that if mm is NULL, system will call Oops anyway.
> However, since it's oops, it does not stop the system, nor call kdump.
>
> That would be a huge bug in kdump?  Surely it dumps when the kernel oopses?

I'm sorry.
Oops did dump on my home pc. But it didn't on my office pc.
I'll take back the patch, and check what I've done wrong at office.


> But there are probably a million potential NULL-pointer dereferences in the
> kernel.  Why single out this one?

I was interested in "Bad swap file entry" problem.

I expereiced this myself. After (quite a lot of ) "Bad swap file
entry" error log from kernel, it Oopsed three times, then kernel was
dead ( It's almost three years from now, so this was without kdump ).

I did find that three Oops happened inside page_referenced() function,
and that it was due to NULL pointer. In 2.6.24, it was only this "mm"
and one more in page_referenced_file() that did not have NULL pointer
check.

So I was really thinking about two more patches. One for "mappers"
NULL pointer check, and other one is to add msr printout when Oops or
Pank happens , to make sure that when Oops or Paniced, still my PC is
not broken.


I needed the evidence so that I don't have to worry about
broken Memory, nor broken Cache.
and I think we still do not have MSRs dumped out as
part of kdump..
# Am I wrong again??
-- 
Kenichi Okuyama
URL: http://www.dd.iij4u.or.jp/~okuyamak/
