Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbXJXWC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbXJXWC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXJXWCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:02:19 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:50416 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754289AbXJXWCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:02:18 -0400
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Simon Arlott <simon@fire.lp0.eu>,
       Adrian Bunk <bunk@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0710242342540.17781@fbirervta.pbzchgretzou.qr>
References: <20071023051642.GA3908@sequoia.sous-sol.org>
	 <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org>
	 <55615.simon.1193226629@5ec7c279.invalid>
	 <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk>
	 <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr>
	 <471F9603.9080308@simon.arlott.org.uk>
	 <Pine.LNX.4.64.0710242059500.17781@fbirervta.pbzchgretzou.qr>
	 <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil>
	 <20071024213704.GA2867@sergelap.austin.ibm.com>
	 <Pine.LNX.4.64.0710242342540.17781@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 18:02:15 -0400
Message-Id: <1193263335.30930.98.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-24 at 23:51 +0200, Jan Engelhardt wrote:
> On Oct 24 2007 16:37, Serge E. Hallyn wrote:
> >
> >Or, a better example, a privileged program reads some sensitive data -
> >as allowed by multiadm, writes it to a file, but apparmor prevented it
> >from chowning the file to the right user before writing,
> 
> Interesting find, I should pay attention to that :-)
> 
> But - note to dquigley - AFAICS, an LSM needs to _explicitly_ call
> the next LSM's function. No one (just a minimal grep in
> linux-2.6/security/) besides SELinux does that today. So
> while you could load AppArmor ontop of MultiAdm, it would never
> be invoked. This is what is known as "sufficient" in PAM parlance.
> SELinux OTOH is in "required" mode [again PAM-speak].

True but if we are talking about a true stackable architecture calling
down to your lower component shouldn't be an option it should be a
requirement of the semantics. I would hate to think some module which is
a subset of the restrictiveness of another could override it because its
"sufficient". If that was the case I could load in a module which just
returns 0 for everything and make it "sufficient" bypassing every other
module. This also introduces ordering dependencies. If you install
MultiAdm before AppArmor or SELinux and make it "sufficient" then you
defeated the point of having AppArmor or SELinux installed in the first
place. 

Dave

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

