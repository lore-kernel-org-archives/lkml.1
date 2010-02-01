Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0BAKi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:38:26 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:33331 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0BAKiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:38:24 -0500
Subject: Re: debug: nt_conntrack and KVM crash
From: Jon Masters <jonathan@jonmasters.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>
In-Reply-To: <b6fcc0a1002010225u4e74f9f0q633d73038234dc37@mail.gmail.com>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant> <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
	 <1265019160.2848.14.camel@edumazet-laptop>
	 <b6fcc0a1002010225u4e74f9f0q633d73038234dc37@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 01 Feb 2010 05:38:15 -0500
Message-Id: <1265020695.7499.151.camel@tonnant>
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

On Mon, 2010-02-01 at 12:25 +0200, Alexey Dobriyan wrote:
> On Mon, Feb 1, 2010 at 12:12 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le lundi 01 février 2010 à 11:36 +0200, Alexey Dobriyan a écrit :
> >> On Mon, Feb 1, 2010 at 11:32 AM, Jon Masters <jonathan@jonmasters.org> wrote:
> >> > I hacked up a per-namespace version of hashtables (this needs doing
> >> > anyway, since the global stuff is just waiting to break)
> >>
> >> Which ones? Conntrack hashtables are per-netns.
> >
> > It seems they are, but this is not a complete work :

That's my point.

> They are per-netns.
> 
> It's not "complete", because right now there is no point in doing more.
> nf_conntrack_max was rejected given the absense of per-netns kernel
> memory consumption limiting.
> 
> > 1) Global settings (shared by all netns)
> 
> Only hashtable size which is module parameter and
> there is no generic way to limit kernel memory (like beancounters).

And can be changed at any time you like (also an exported symbol) such
that existing hashtable indexing will fail and corrupt memory. There is
clearly a need for each of these hashtables to have its own metadata.

Jon.


