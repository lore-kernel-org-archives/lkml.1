Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbZFWBFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbZFWBFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZFWBFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:05:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:53155 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbZFWBFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:05:12 -0400
Subject: Re: [git pull] drm: previous pull req + 1.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       Dave Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
       Andrew Lutomirski <luto@mit.edu>, dri-devel@lists.sf.net,
       Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0906221721450.3240@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <4A3DABE1.50309@mit.edu>
	 <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	 <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	 <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	 <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	 <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	 <4A3F3E3A.2030202@shipmail.org> <1245715213.4017.13.camel@pasglop>
	 <alpine.LFD.2.01.0906221721450.3240@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 11:04:39 +1000
Message-Id: <1245719079.4017.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 17:24 -0700, Linus Torvalds wrote:
> 
> On Tue, 23 Jun 2009, Benjamin Herrenschmidt wrote:
> > 
> > As far as I can remember, all fbdev operations are done under the
> > console semaphore.
> 
> Yeah, and some of them are horribly broken (ie copying data from user 
> space while doing it - causing horrible things like VC switching latencies 
> and invisible printk's if an oops happens during the op).
> 
> Or maybe that got fixed. 

Well, it does rely on userspace behaving.. ie, no accel ops are done by
the kernel in KD_GRAPHICS and userspace is -supposed- to switch to
KD_GRAPHICS before touching the fb.

In fact, nowdays, we do have the infrastructure to be smart and enforce
that. IE. Instead of using a boring remap_page_ranges() in fb_mmap() we
could use a fault handler. When in KD_TEXT, we fail them, when in
KD_GRAPHICS, we service them, and we unmap_mapping_range() when
switching. Something like that...

Dunno how that interacts with the new DRM thingy though.

Cheers,
Ben.

