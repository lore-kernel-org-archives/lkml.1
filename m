Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbZAFGbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbZAFGbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 01:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZAFGbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 01:31:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45211 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZAFGbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 01:31:43 -0500
Date: Tue, 6 Jan 2009 15:30:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, npiggin@suse.de, riel@redhat.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow v2
Message-Id: <20090106153036.1263b5ab.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090106145741.e9844b93.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090105103132.GD7645@localhost>
	<20090105163742.08777d73.akpm@linux-foundation.org>
	<20090106145741.e9844b93.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009 14:57:41 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 5 Jan 2009 16:37:42 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 5 Jan 2009 13:31:32 +0300
> > Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > 
> > > __nr_to_section should check for array bound overflow.
> > > We should better get NULL dereference then silently
> > > pass some memory snippet out of bounds to a caller.
> > > 
> > 
> > Are there actually any known problems here?
> > 
> 
> IIRC, I never saw any problem. (But I may see in memory-hotplug development.)

I digged mails and seems this patch is from this thread.

=
http://lkml.org/lkml/2009/1/4/61
=

He seems to want to hunt boot time failure.
(Finally, BIOS-update was necessary for original problem of this thread.)

Cyrill, could you modify this WARN_ON() works works when __nr_to_section()
is called directly by sparse.c and memhotplug.c ?

Adding WARN_ON() in pfn_to_page() is overkill.

Thanks,
-Kame

