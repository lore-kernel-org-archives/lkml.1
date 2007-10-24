Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbXJXXOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbXJXXOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbXJXXNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:13:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35844 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbXJXXNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:13:50 -0400
Date: Thu, 25 Oct 2007 01:13:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: "Serge E. Hallyn" <serue@us.ibm.com>, Simon Arlott <simon@fire.lp0.eu>,
       Adrian Bunk <bunk@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <1193263335.30930.98.camel@moss-terrapins.epoch.ncsc.mil>
Message-ID: <Pine.LNX.4.64.0710250100240.17781@fbirervta.pbzchgretzou.qr>
References: <20071023051642.GA3908@sequoia.sous-sol.org>  <471E9260.6000704@goop.org>
 <20071023220649.5a76af82@laptopd505.fenrus.org>  <55615.simon.1193226629@5ec7c279.invalid>
  <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk>
  <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr> 
 <471F9603.9080308@simon.arlott.org.uk>  <Pine.LNX.4.64.0710242059500.17781@fbirervta.pbzchgretzou.qr>
  <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil> 
 <20071024213704.GA2867@sergelap.austin.ibm.com> 
 <Pine.LNX.4.64.0710242342540.17781@fbirervta.pbzchgretzou.qr>
 <1193263335.30930.98.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 24 2007 18:02, David P. Quigley wrote:
>> 
>> But an LSM needs to _explicitly_ call the next LSM's function. No
>> one (just a minimal grep in linux-2.6/security/) besides SELinux
>> does that today. So while you could load AppArmor ontop of
>> MultiAdm, it would never be invoked. This is what is known as
>> "sufficient" in PAM parlance.
>
>I would hate to think some module which is a subset of the
>restrictiveness of another could override it because its
>"sufficient". If that was the case I could load in a module which
>just returns 0 for everything and make it "sufficient" bypassing
>every other module. This also introduces ordering dependencies. If
>you install MultiAdm before AppArmor or SELinux and make it
>"sufficient" then you defeated the point of having AppArmor or
>SELinux installed in the first place.

If I had to run mtadm and aa alongside each other, I would put aa
into the "secondary" LSM slot.

A number of people have said by now that LSM is supposed to be a
restrict-my-rights block of code. As such, I would put the special,
tiny, give-me-rights code at the front so that it be executed first.
This is what would be intended with mtadm. It really just gives you a
few caps when switching to UID 900 (or whatever), just as Linux
traditionally gives you full caps when switching to UID 0 (e.g. by
executing setuid files). From there on, it is just restrictions, and
the order in which LSMs restrict your actions is probably not so
important as long as they do restrict it.

Thankfully, Linux capabilities are so strangely designed that they
actually become useful - they give you so much power that you _can_
only restrict things afterwards again :-)
