Return-Path: <linux-kernel-owner+w=401wt.eu-S1758998AbXJODbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998AbXJODbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 23:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbXJODaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 23:30:55 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:25795 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752981AbXJODay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 23:30:54 -0400
X-YMail-OSG: Mbsq8KQVM1lc_DtqN88qY0iCl2hIvjr7EoAaPjIIA0avzWCWwew5Fbg16XjJN.JyKF0ZuRYuag--
X-RocketYMMF: rancidfat
Date: Sun, 14 Oct 2007 20:30:53 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 7 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071014231358.GA5565@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <779660.41682.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi Casey,
> 
> On Sun, Oct 14, 2007 at 10:15:42AM -0700, Casey Schaufler wrote:
> > 
> > +
> > +CIPSO Configuration
> > +
> > +It is normally unnecessary to specify the CIPSO configuration. The default
> > +values used by the system handle all internal cases. Smack will compose
> CIPSO
> > +label values to match the Smack labels being used without administrative
> > +intervention. 
> >
> 
> I have two issues with CIPSO and Smack:
> 
> 1-
> 
> Using default configuration (system startup script + smacfs fstab line),
> system
> can't access any service outside the Lan. "ICMP parameter problem message"
> always
> appear from the first Wan router (traceroute + tcpdump at [1]).
> 
> Services inside the LAN can be accessed normally. System can connect to a Lan
> Windows share. It also connects to the gateway HTTP server easily.
> 
> After some tweaking, I discovered that using CIPSOv6 solves all above
> problems:
> $ echo -n "NLBL_CIPSOv6" > /smack/nltype
> 
> Is this a normal behaviour ?

Well ... sort of. CIPSOv6 isn't actually implemented in the
labeled networking code. What you're seeing is unlabeled packets.

As far as CIPSOv4 and your WAN router, It is possible that it is
configured either to reject CIPSO packets or to allow only CIPSO
packets in a particular DOI or to enforce a CIPSO policy of its
own.

> 2-
> 
> > 4. Any access requested on an object labeled "*" is permitted.
> [...]
> > +Unlabeled packets that come into the system will be given the
> > +ambient label.
> 
> Default conf let the ambient attribute = _ which works fine. Setting ambient
> = *
> stops all external (non lo) network traffic. Did I miss another use of
> "ambient"
> or this is a normal behaviour ?.

An IP operation is considered a write from the sender to the receiver.
The packet label is the label of the sender. Thus, in the unlabeled
packet case, the ambient label ("*" in your case) is attached to packet,
and the access check always denies access because of the first access
rule, which is that a subject with a star label will always be denied
access.

> > +Administration
> > +
> > +Smack supports some mount options:
> > +
> > +	smackfsdef=label: specifies the label to give files that lack
> > +	the Smack label extended attribute.
> > +
> 
> Although using smackfsdef=* as a mount option, all my system files have the
> floor
> attribute. Most of the /dev files have the * attribute though.

The smackfsdef mount option applies to files that don't actually
have the security.SMACK64 attribute. If those files have the attribute
whatever value is associated with it will be used.


Thank you.


Casey Schaufler
casey@schaufler-ca.com
