Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092Ab0A3KD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab0A3KD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 05:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349Ab0A3KD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 05:03:26 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:46828 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab0A3KDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 05:03:23 -0500
Subject: Re: debug: nt_conntrack and KVM crash
From: Jon Masters <jonathan@jonmasters.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>
In-Reply-To: <1264840415.2919.19.camel@edumazet-laptop>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant>  <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop> <1264836971.7499.4.camel@tonnant>
	 <1264840415.2919.19.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Sat, 30 Jan 2010 05:03:14 -0500
Message-Id: <1264845794.7499.10.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 09:33 +0100, Eric Dumazet wrote:
> Le samedi 30 janvier 2010 à 02:36 -0500, Jon Masters a écrit :
> 
> > I'll play later. Right now, I'm looking over every iptables/ip call
> > libvirt makes - it explicitly plays with the netns for the loopback,
> > which looks interesting. Supposing it does cause the hashtables to get
> > unintentionally zereod or the sizing to get wiped out, we should also
> > nonetheless catch the case that the hash function generates a whacko
> > number or that the hash size is set to zero when we want to use it.

> I asked you if you had multiple namespaces, because I was not sure
> conntracking hash was global (shared by all namespaces), or local.

Well, I didn't think I had multiple namespaces, and in fact I don't see
more than one in gdb when I poke at the net struct. What I see libvirt
doing (very oddly indeed - looking at the source now) is calling ip and
asking for the lo device to be moved into the netns for pid "-1", which
isn't valid AFAIK (should be a valid pid, unless "-1" is supposed to be
"this process" or something, haven't played with multiple namespaces).

I'll do some more digging (network stuff isn't my area) now and come
back. It only reproduces if multiple VMs start at once (hence a race,
perhaps as you describe) whereas if I disable autostart and let them
come up one at a time, the box doesn't roll over.

Jon.


