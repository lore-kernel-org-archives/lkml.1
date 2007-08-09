Return-Path: <linux-kernel-owner+w=401wt.eu-S940261AbXHIMtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940261AbXHIMtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940102AbXHIMrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:47:32 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:59166 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939881AbXHIMra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:47:30 -0400
Date: Thu, 9 Aug 2007 08:46:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Glauber de Oliveira Costa <glommer@gmail.com>, lguest@ozlabs.org,
       "Nakajima, Jun" <jun.nakajima@intel.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, anthony@codemonkey.ws,
       akpm@linux-foundation.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, mingo@elte.hu
Subject: Re: [Lguest] Introducing paravirt_ops for x86_64
In-Reply-To: <46BAA799.7080806@goop.org>
Message-ID: <Pine.LNX.4.58.0708090843160.29847@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
 <97D612E30E1F88419025B06CB4CF1BE10326E129@scsmsx412.amr.corp.intel.com>
 <5d6222a80708080758t1b937d0ej14c5e60ac23a20c5@mail.gmail.com>
 <46BAA799.7080806@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Wed, 8 Aug 2007, Jeremy Fitzhardinge wrote:

>
> At the moment Xen can't support guests with 2M pages.  In 32-bit this
> isn't a huge problem, since the kernel doesn't assume it can map itself
> with 2M pages.  But I think the 64-bit kernel assumes 2M pages are
> always available for mapping the kernel.  I don't know how pervasive
> this assumption is, but it would be nice to parameterize it in pv-ops.
>

I got 2M pages working in lguest64, but it was a cause of a lot of pain.
By removing support for 2M pages in guests, that might clean up a lot of
lguest64 shadow paging as well.

The only advantage I see for 2M pages or a guest, is that it saves the
guest from having extra page tables. The host still needs the map the 2M
to 4K, so it's not an advantage there. It doesn't speed anything up, so
I'd be all for scrapping 2M pages for guests.

-- Steve

