Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbZD3VRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbZD3VRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762065AbZD3VRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:17:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762271AbZD3VRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:17:33 -0400
Date: Thu, 30 Apr 2009 14:10:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       mpm@selenic.com, clameter@sgi.com, mingo@elte.hu,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] use GFP_NOFS in kernel_event()
Message-Id: <20090430141041.c167b4d4.akpm@linux-foundation.org>
In-Reply-To: <1241097573.6020.7.camel@localhost.localdomain>
References: <20090430020004.GA1898@localhost>
	<20090429191044.b6fceae2.akpm@linux-foundation.org>
	<1241097573.6020.7.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 09:19:33 -0400
Eric Paris <eparis@redhat.com> wrote:

> > Somebody was going to fix this for us via lockdep annotation.
> > 
> > <adds randomly-chosen cc>
> 
> I really didn't forget this, but I can't figure out how to recreate it,
> so I don't know if my logic in the patch is sound.  The patch certainly
> will shut up the complaint.

Do you think we should merge the GFP_NOFS workaround for 2.6.30 and
fix all up nicely for 2.6.31?

GFP_NOFS isn't all that bad, really - it will work sufficiently well. 
Being able to switch it over to GFP_KERNEL later on is a pretty minor
optimisation.  But it would be bad of us to simply forget about it, so I'd
probably end up retaining a switch-back-to-GFP_KERNEL patch in -mm with
which to periodically harrass you guys ;)


