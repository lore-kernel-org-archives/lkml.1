Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbXFXV50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbXFXV50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbXFXV5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:57:09 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:48101
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbXFXV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:57:07 -0400
Date: Sun, 24 Jun 2007 14:57:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <f5mmuu$4d4$1@taverner.cs.berkeley.edu>
Message-ID: <Pine.LNX.4.64.0706241449300.12806@asgard.lang.hm>
References: <46732124.80509@novell.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
 <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain>
 <f5mmuu$4d4$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007, David Wagner wrote:

> Argument 3. AA isn't complete until it mediates network and IPC.
>
> Let me comment on these one-by-one.
>
> 3. This one I agree with.  If you want to sandbox network daemons that
> you're concerned might get hacked, then you really want your sandbox to
> mediate everything.  Right now the security provided by AA (if that's
> what you are using it for) will be limited by its incomplete mediation,
> since a knowledgeable motivated attacker who hacks your daemon may be
> able to use network or IPC to break out of the sandbox, depending upon
> the network and host configuration.  Filesystem mediation alone might be
> better than nothing, I suppose, if you're worried about script kiddies,
> but it's certainly not a basis for strong security claims.  The state of
> the art in sandboxing obviously requires complete mediation, and we've
> known that for a decade.

the issue I see is that AA may not have to implement any new in-kernel 
infrastructure to do this.

as recently as yesterday there have been discussions on the netfilter list 
about how to implement filter rules based on the application name (see the 
thread titled 'filter by application name') if this gets implemented 
independantly of AA then AA could provide a policy implementation layer 
over netfilter if desired (or sysadmins could just use their current 
favorite tool to control the network and AA to control the filesystem)

so holding up AA becouse this isn't implemented yet seems to be counter 
productive. people are working on this, and it is going to go in at some 
point independantly of AA, so why tie AA to it?

IPC is a very imprecise term. it includes lots of different ways for 
processes to communicate with each other. some forms of IPC are covered by 
AA today (unix sockets), others aren't. but each of the different methods 
is going to involve some difference in how it's controlled. if you want to 
talk IPC be specific about what IPC methods you are talking bout limiting.

David Lang
