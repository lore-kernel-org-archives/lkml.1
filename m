Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbYB1WHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbYB1WHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758996AbYB1WHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:07:04 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbYB1WHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:07:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=dJTR2c/mcdWRgVCXI4XYKNfrqL7fbbnp2YzcUyvGXdfWR4mIz6+FhSRI3IWE/6RcD
	Aj5m5pJIXfuU7BwzphIPw==
Message-ID: <6599ad830802281406s512ee32bkeb2b0387a7737a87@mail.gmail.com>
Date: Thu, 28 Feb 2008 14:06:44 -0800
From: "Paul Menage" <menage@google.com>
To: serge@hallyn.com
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
Cc: "Andrew Morton" <akpm@linux-foundation.org>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl, xemul@openvz.org, pj@sgi.com
In-Reply-To: <20080228213319.GC1232@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
	 <20080228132142.4d4b1eef.akpm@linux-foundation.org>
	 <6599ad830802281328q162d0585v3ac6b45a119a4a05@mail.gmail.com>
	 <20080228213319.GC1232@vino.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 1:33 PM,  <serge@hallyn.com> wrote:
>
>  You said the set of files belong to cgroup itself is likely to increase
>  - do you have some candidates in mind?

Nothing concrete right now. One example that I already proposed was
the "cgroup.api" file but that's shelved for now, until such time as I
actually propose the binary API that it was intended to help support.

> Perhaps ones which are likely
>  to conflict with choice taskgroup names?

It's hard to determine what likely taskgroup names would be. For my
own use, pretty much every group has a unique 64-bit ID in the name so
this isn't something I worry about directly affecting our systems. But
I don't know what other users might want to do.

>
>  If anything I'd say add a 'prefix_cgroup' mount option and use it to
>  decide whether to prefix or not (rather than use the noprefix option).

The existing "noprefix" option controls whether the *subsystems* get
prefixes. It's mainly there to provide backwards compatibility for
cpusets. Existing cpusets clients would be expecting to find files
with names like "mems_allowed" rather than "cpuset.mems_allowed". So
mounting with the "noprefix" option (which happens automatically when
you mount the "cpuset" filesystem wrapper) gives the same result as
before.

Currently "noprefix" has no effect on cgroup files, since they never
have a prefix anyway.

Yes, we could add a new mount option "prefixcgroup", and let people
decide which they want. But I still don't see any argument *against*
doing the prefixing automatically (rather than an argument that it's
no better or worse) other than wanting 2.6.24 compatibility.

Paul
