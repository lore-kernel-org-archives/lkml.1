Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXJXVv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXJXVv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760146AbXJXVvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:51:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57906 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759673AbXJXVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:51:14 -0400
Date: Wed, 24 Oct 2007 23:51:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       Simon Arlott <simon@fire.lp0.eu>, Adrian Bunk <bunk@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <20071024213704.GA2867@sergelap.austin.ibm.com>
Message-ID: <Pine.LNX.4.64.0710242342540.17781@fbirervta.pbzchgretzou.qr>
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org>
 <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid>
 <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk>
 <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr>
 <471F9603.9080308@simon.arlott.org.uk> <Pine.LNX.4.64.0710242059500.17781@fbirervta.pbzchgretzou.qr>
 <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil>
 <20071024213704.GA2867@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 24 2007 16:37, Serge E. Hallyn wrote:
>
>Or, a better example, a privileged program reads some sensitive data -
>as allowed by multiadm, writes it to a file, but apparmor prevented it
>from chowning the file to the right user before writing,

Interesting find, I should pay attention to that :-)

But - note to dquigley - AFAICS, an LSM needs to _explicitly_ call
the next LSM's function. No one (just a minimal grep in
linux-2.6/security/) besides SELinux does that today. So
while you could load AppArmor ontop of MultiAdm, it would never
be invoked. This is what is known as "sufficient" in PAM parlance.
SELinux OTOH is in "required" mode [again PAM-speak].
