Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYHUIfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYHUIfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYHUIew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:34:52 -0400
Received: from eisentraut.org ([85.214.91.16]:60760 "EHLO gattler.pezone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYHUIev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:34:51 -0400
From: Peter Eisentraut <peter_e@gmx.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bugme-new] [Bug 11381] New: default shmmax
Date: Thu, 21 Aug 2008 11:08:43 +0300
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>,
       Pierre Peiffer <peifferp@gmail.com>, containers@lists.osdl.org
References: <bug-11381-10286@http.bugzilla.kernel.org/> <20080820120043.e6e7e436.akpm@linux-foundation.org> <20080820195509.00994d51@lxorguk.ukuu.org.uk>
In-Reply-To: <20080820195509.00994d51@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211108.46443.peter_e@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > It would be useful to get distro input on this.  Do they override the
> > kernel default at boot time?  If so, what do they do?
>
> Red Hat provide a sysctl tuning config file and I believe things like the
> Oracle install docs cover this.
>
> There is btw no earthly reason why a postgres package can't include a
> tool to do this or postgres can't check and update it as part of its
> own set up and config file options

I have explored this, it would be possible, but it would be a pain in the 
neck.  You'd need to add an option to postgres to print out how much shared 
memory you would need for a given configuration (because there are multiple 
factors in this), run this across all postgres instances on the machine, sum 
it up, then arrange for this to be fed back to sysctl or pasted back into 
sysctl.conf, being careful not to override or lower an existing setting that 
might have wanted to reserve space for other things.  Note that to make this 
robust you would have to rerun this after every configuration change + 
restart cycle across all postgres instances on the machine, race conditions 
included.  And you'd probably violate a few packaging guidelines on the way.  
Plus, this would have to be distro-specific (not Linux-specific, but 
distro-specific), doesn't help managed hosting with no root access, and 
doesn't help people building from source.  So altogether it is very 
complicated.

In the meantime I am trying to explore why the shmmax default is what it is.  
Or why it has to exist at all.  If we can figure that out, maybe we can solve 
a lot of users a lot of trouble with much less effort (including Oracle 
users, why not).
