Return-Path: <linux-kernel-owner+w=401wt.eu-S933786AbXCKPvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786AbXCKPvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 11:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933787AbXCKPvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 11:51:37 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:47863 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbXCKPvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 11:51:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JiMDlL9kWCEltHQYq2Un4v14XpXskxeLSCW2n4nHjLP6HTOrOSg6sbH1DkuxrLRV6UiLa4+wbocsNafs/oDvH+gzGIQ1rcqU3Zg+/xHwFyIOmje6yO3ObOgF/Jv9jScHMM5Ow7XwIcWnM+P7qrAHYRmNn1A3E0dadWU5WkujTE8=
Message-ID: <661de9470703110851h74656692m8d1fd8aa028237d8@mail.gmail.com>
Date: Sun, 11 Mar 2007 21:21:30 +0530
From: "Balbir Singh" <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Cc: "Kirill Korotaev" <dev@sw.ru>, xemul@sw.ru, menage@google.com,
       vatsa@in.ibm.com, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-Reply-To: <20070311045111.62d3e9f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	 <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <45F3F581.9030503@sw.ru>
	 <20070311045111.62d3e9f9.akpm@linux-foundation.org>
X-Google-Sender-Auth: 648c350ccf62edd6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sun, 11 Mar 2007 15:26:41 +0300 Kirill Korotaev <dev@sw.ru> wrote:
> > Andrew Morton wrote:
> > > On Tue, 06 Mar 2007 17:55:29 +0300
> > > Pavel Emelianov <xemul@sw.ru> wrote:
> > >
> > >
> > >>+struct rss_container {
> > >>+   struct res_counter res;
> > >>+   struct list_head page_list;
> > >>+   struct container_subsys_state css;
> > >>+};
> > >>+
> > >>+struct page_container {
> > >>+   struct page *page;
> > >>+   struct rss_container *cnt;
> > >>+   struct list_head list;
> > >>+};
> > >
> > >
> > > ah.  This looks good.  I'll find a hunk of time to go through this work
> > > and through Paul's patches.  It'd be good to get both patchsets lined
> > > up in -mm within a couple of weeks.  But..
> > >
> > > We need to decide whether we want to do per-container memory limitation via
> > > these data structures, or whether we do it via a physical scan of some
> > > software zone, possibly based on Mel's patches.
> > i.e. a separate memzone for each container?
>
> Yep.  Straightforward machine partitioning.  An attractive thing is that it
> 100% reuses existing page reclaim, unaltered.

We discussed zones for resource control and some of the disadvantages at
              http://lkml.org/lkml/2006/10/30/222

I need to look at Mel's patches to determine if they are suitable for
control. But in a thread of discussion on those patches, it was agreed
that memory fragmentation and resource control are independent issues.


>
> > imho memzone approach is inconvinient for pages sharing and shares accounting.
> > it also makes memory management more strict, forbids overcommiting
> > per-container etc.
>
> umm, who said they were requirements?
>

We discussed some of the requirements in the RFC: Memory Controller
requirements thread
                                 http://lkml.org/lkml/2006/10/30/51

> > Maybe you have some ideas how we can decide on this?
>
> We need to work out what the requirements are before we can settle on an
> implementation.
>
> Sigh.  Who is running this show?   Anyone?
>

All the stake holders involved in the RFC discussion :-) We've been
talking and building on top of each others patches. I hope that was a
good answer ;)

> You can actually do a form of overcommittment by allowing multiple
> containers to share one or more of the zones.  Whether that is sufficient
> or suitable I don't know.  That depends on the requirements, and we haven't
> even discussed those, let alone agreed to them.
>

There are other things like resizing a zone, finding the right size,
etc. I'll look
at Mel's patches to see what is supported.

Warm Regards,
Balbir Singh
