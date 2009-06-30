Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZF3U0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZF3U0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZF3U0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:26:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43509 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbZF3U0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:26:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Do44QdNvkp2uAf9TNC/Q6YqHdpykNw1J2XIvWpXkkKpUNnfE3efkrcJioxnsvK2dV
	R2pl4/CGY2SVDDOUdTvZQ==
Date: Tue, 30 Jun 2009 13:25:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <84144f020906300124n24e206b5tc85dd5cc4661bde7@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0906301318270.20326@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net> <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com> <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
 <alpine.DEB.2.00.0906300032310.11018@chino.kir.corp.google.com> <84144f020906300124n24e206b5tc85dd5cc4661bde7@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Pekka Enberg wrote:

> On Tue, Jun 30, 2009 at 10:47 AM, David Rientjes<rientjes@google.com> wrote:
> > I don't think CONFIG_SLUB_DEBUG_ON is generally the configuration used in
> > the real world.
> 
> It is, hence the epic bug report that's eaten too many man hours
> already! Look, we encourage _testers_ to turn all as much as debugging
> options as possible so we catch bugs early. That why the only sane
> defaults are the ones that don't cause other problems!
> 

I feel that asking a user to add a command line parameter such as 
`slub_debug=A' in addition to CONFIG_SLUB_DEBUG_ON will likely lead to 
less testing coverage and bugs going unreported.  CONFIG_SLUB_DEBUG_ON is 
not something that a distro is going to enable or would be used in a 
production environment, it's something that's used to debug slub and/or 
slab allocations either during the development of new kernel code or when 
an underlying problem is realized.

> I don't know why you want to argue this. It's simply not an option to
> say "stupid user, fix your config" in core code like the slab
> allocator. Enabling CONFIG_SLUB_DEBUG_ON is a very reasonable thing to
> do when you are a tester looking for bugs.
> 

Quite the contrary, I agree completely with the above, and that's why I'm 
arguing for full debugging to be enabled when a well-defined configuration 
option is enabled.  I simply don't believe that such debugging should be 
coupled with a command line option to be fully activated for all caches.
