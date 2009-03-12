Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbZCLXV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbZCLXV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZCLXVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:21:19 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:60148 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZCLXVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=na5bzZOnppqIKDJG/hy+Cz1fvgX3gs7FuCNXQIO+W3QoYxw7RlREx3TkkPHXK8q/5w
         uhBXM+FygvK1Nuqz/Di2QY1be57f7/n5xL93aoUXGkzwepROmQWzpKaPB3jKFpJ0976C
         1SfmB0/L+Z7dMTj0HvcVFprmA/wX81VhIXSDM=
Date: Fri, 13 Mar 2009 08:20:51 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jamie Lokier <jamie@shareable.org>,
       uClinux development list <uclinux-dev@uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] RE: [PATCH] NOMMU: Pages allocated to a ramfs
 inode's pagecache may get wrongly discarded
Message-Id: <20090313082051.5eaa11a3.minchan.kim@barrios-desktop>
In-Reply-To: <1236858608.22914.3689.camel@twins>
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
	<20090311170840.2f136849.akpm@linux-foundation.org>
	<5DC5324CE00E4D4494EE5F031E354E9501CE9C0F@BUDMLVEM03.e2k.ad.ge.com>
	<20090312112953.GD6995@shareable.org>
	<1236858608.22914.3689.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter.

On Thu, 12 Mar 2009 12:50:08 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-03-12 at 11:29 +0000, Jamie Lokier wrote:
> > Berkhan, Enrik (GE Infra, Oil & Gas) wrote:
> > > Andrew Morton wrote:
> > > > On Wed, 11 Mar 2009 15:30:35 +0000
> > > > David Howells <dhowells@redhat.com> wrote:
> > > >> From: Enrik Berkhan <Enrik.Berkhan@ge.com>
> > > >> 
> > > >> The solution is to mark the pages dirty at the point of allocation by
> > > >> the truncation code.
> > > > 
> > > > Was there a specific reason for using the low-level SetPageDirty()?
> > > 
> > > No, no specific reason. It was just my first try of a fix after spotting 
> > > the problem. After a short discussion with David, we decided to wait for 
> > > others' comments on using the low-/high-level approach.
> > 
> > Tangentially related...
> > 
> > Does the vm pageout logic include or skip these "dirty" pages looking
> > for candidates to flush to storage?  What about with MMU?
> 
> Includes them, regular pageout will try to do the writeout to clean them
> and then discard them. 
> 
> The ramfs stuff is rather icky in that it adds the pages to the aging
> list, marks them dirty, but does not provide a writeout method. 
> 
> This will make the paging code scan over them (continuously) trying to
> clean them, failing that (lack of writeout method) and putting them back
> on the list.

It ins't true any more. 
UNEVICTABLE_LRU will move ramfs's page from LRU to unevictable list.
Couldn't we solve this problem if NOMMU can support CONFIG_UNEVICTABLE_LRU ?


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Kinds Regards
Minchan Kim
