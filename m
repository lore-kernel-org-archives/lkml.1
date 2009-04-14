Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZDNQx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZDNQx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbZDNQxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:53:17 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42553 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546AbZDNQxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fw/Fz4foPz5qBExAusgajGE+2Pg4J/ALiCTbz1fLR76SvsP3yWgNd7+WmHoXUIxTkS
         MQTbqLJrold+a84yULCmdqORIYgqyts5l3C3/at6mjV87JEJptMgoCD6t3IbMcpK1Qy9
         ejBwqPHbkPK1UbBa8E0m+I7oGvw3z7o6XiIos=
Date: Tue, 14 Apr 2009 20:53:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       serue@us.ibm.com, dave@linux.vnet.ibm.com, orenl@cs.columbia.edu,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090414165325.GA27923@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <alpine.LFD.2.00.0904100758410.4583@localhost.localdomain> <20090413073925.GB7085@x200.localdomain> <alpine.LFD.2.00.0904131137520.26713@localhost.localdomain> <20090414122906.GA20201@x200.localdomain> <20090414134420.GC27163@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414134420.GC27163@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 03:44:20PM +0200, Ingo Molnar wrote:
> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Mon, Apr 13, 2009 at 11:39:51AM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Mon, 13 Apr 2009, Alexey Dobriyan wrote:
> > > > 
> > > > Well, in OpenVZ everything is in kernel/cpt/ and prefixed with "cpt_"
> > > > and "rst_".
> > > 
> > > So?
> > > 
> > > We're not merging OpenVZ code _either_.
> > 
> > This is to give example of other prefixes: cpt_ and rst_
> > Are they fine?
> 
> Not really. 'rst' can be easily mistaken for 'reset' and neither 
> really tells me at a glance what they do. They are also quite 
> tongue-twisters.
> 
> See my namespace analysis and suggestions from yesterday for a 
> proper naming scheme.
> 
> The key i believe is to move away from this singular 'the world is 
> all about checkpoint and restore', and move it to a IMHO clearer 
> state_*() type of naming which really isolates all these kernel 
> state save/restore management APIs from other kernel APIs. (See my 
> mail from yesterday for details.)
> 
> kstate_*() would be another, perhaps even clearer naming scheme. 
> I.e.:
> 
>   kstate_checkpoint_XYZ()
>   kstate_restore_XYZ()
>   kstate_collect_XYZ()
>   kstate_dump_XYZ()
>   kstate_image_XYZ()
>   ...
> 
> Just _look_ at them - they are expressive at a glance, and 
> reasonably short. That is the kind of first-time impression
> we need, not a 'wtf?' moment.
> 
> I just checked, there's zero hits on "git grep \<kstate_" in the 
> kernel, so it's a pristine namespace. IMHO, go wild ...

Need to try it for real.

One minor nit. This kstate_ doesn't include quite a noticable of
in-kernel state. For example, task readahead state isn't relevant
to C/R at all. It's state but irrelevant state.
