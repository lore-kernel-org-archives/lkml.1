Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYCMWK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYCMWK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYCMWKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:10:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:15754 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYCMWKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O37lKnjwfXdLw4B3s7ypTfBY0+4xccgzzri0UiOHJZGg65JUe/4k1vve5qZSD1+M+BMA9c3cUPJ8A06yW4e1n9+uNjrL8qe3oBTvfsqEQ1XrwUUeiySzk0fcJfeKa2tuljnD2kwV9Zmr7sMEnjsogx9nUjPgZAfsjs3BBiU5xvY=
Message-ID: <86802c440803131510m30621bd7p6446826a5f121395@mail.gmail.com>
Date: Thu, 13 Mar 2008 15:10:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: free_bootmem should take phy
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org, ak@suse.de,
       y-goto@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20080313150441.014c96f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803131213i4e19002an859a3f3ffb109727@mail.gmail.com>
	 <20080313150441.014c96f9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 3:04 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 13 Mar 2008 12:13:23 -0700
>  "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>  > [PATCH] x86_64: free_bootmem should take phys
>  >
>  > so use nodedata_phys directly.
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  >
>  > diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
>  > index 0c9b2bd..18267a0 100644
>  > --- a/arch/x86/mm/numa_64.c
>  > +++ b/arch/x86/mm/numa_64.c
>  > @@ -221,8 +221,7 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
>  >                                bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
>  >       if (bootmap == NULL)  {
>  >               if (nodedata_phys < start || nodedata_phys >= end)
>  > -                     free_bootmem((unsigned long)node_data[nodeid],
>  > -                                  pgdat_size);
>  > +                     free_bootmem(nodedata_phys, pgdat_size);
>  >               node_data[nodeid] = NULL;
>  >               return;
>  >       }
>  >
>
>  Can you please confirm that this change has no dependency upon your other
>  recent changes?
it has not dependency upon to other recent changes.

YH
