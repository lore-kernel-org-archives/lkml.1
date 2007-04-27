Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbXD0HUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbXD0HUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXD0HUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:20:55 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45160 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbXD0HUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:20:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=gQdbI5R7IWr6K5BGqG9ldC50FtRF0gr1P/Q2JV/m4F0gQDdkD78vimSjm9JRfFPL/
	C6hupaXlV7YBDTzieyv7g==
Date: Fri, 27 Apr 2007 00:19:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <clameter@engr.sgi.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] oom: fix constraint deadlock
In-Reply-To: <20070427001228.e94ea60f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704270018100.5200@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0704262243370.3461@chino.kir.corp.google.com>
 <20070427001228.e94ea60f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Andrew Morton wrote:

> > Subject: [patch -mm] oom: fix constraint deadlock
> > Date: Thu, 26 Apr 2007 23:18:17 -0700 (PDT)
> > 
> > Fixes a deadlock in the OOM killer for allocations that are not
> > __GFP_HARDWALL.
> 
> Thanks.
> 
> Why is this described as "patch -mm"?  It applies to mainline.  If it's
> fixing a -mm patch, do you know which one?
> 

Fair enough.  It definitely is applicable to mainline and fixes a deadlock 
which we've been struggling with for awhile because not only does it block 
while holding callback_mutex, but also tasklist_lock.

Thanks.
