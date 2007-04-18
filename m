Return-Path: <linux-kernel-owner+w=401wt.eu-S1030989AbXDRBeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030989AbXDRBeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 21:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030981AbXDRBeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 21:34:24 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:41007 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030989AbXDRBeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 21:34:22 -0400
Date: Tue, 17 Apr 2007 21:34:19 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: David Wagner <daw@cs.berkeley.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <f03fgh$2o1$1@taverner.cs.berkeley.edu>
Message-ID: <Line.LNX.4.64.0704172036370.21359@d.namei>
References: <20070417181016.GA10903@one.firstfloor.org>
 <657751.18080.qm@web36614.mail.mud.yahoo.com> <20070417211653.GB11944@one.firstfloor.org>
 <1176846088.5946.62.camel@localhost.localdomain> <f03fgh$2o1$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, David Wagner wrote:

> be more usable than SELinux.  Even if SELinux is more "complete"
> than AppArmor, I might still prefer ease of use over completeness
> and understandability.

I would challenge the claim that AppArmor offers any magic bullet for
ease of use.  There are plenty of examples of people disabling it because 
their apps stop working:

http://lists.opensuse.org/opensuse/2006-07/msg02440.html

  "Suddenly I have to disable AppArmor to start postfix."

Sound familiar ?

I'd also challenge the idea that the pathname policy scheme is easy enough 
for users to understand and meaningfully manage.  The chief architect of 
the project can't explain a simple policy he used to demonstrate its 
simplicity:

http://marc.info/?l=full-disclosure&m=114429157431167&w=2

"
  >  but as you posted an example profile with "capability setuid", I must
  > admit I am curious as to why an email client needs that.

  Well now that is a very good question, but it has nothing to do with
  AppArmor. The AppArmor learning mode just records the actions that the
  application performs. With or without AppArmor, the Thunderbird mail
  client is using cap_setuid. AppArmor gives you the opportunity to *deny*
  that capability, so you can try blocking it and find out. But for
  documentation on why Thunderbird needs it, you would have to look at
  mozilla.org not the AppArmor pages.

"

What this is demonstrates is that usability has nothing to do with 
pathnames or labels, and that the underlying complexity of the system 
dominates the issue.  In this case, the application needs a certain 
capability -- setuid, no less -- and the user doesn't understand why.  At 
this point, AppArmor loses its claimed transparency, and the user must 
ultimately understand what the system is doing and why.

SELinux, at the lowest level, simply exposes the complexity of the 
underlying security-relevant interactions of the system for the purposes 
of control.  Usability needs to be addressed at a higher level.

Something that is poorly understood is that SELinux policy was never 
intended to be developed by users.  It's like an assembly-language; it 
provides an extremely low-level mechanism for controlling all 
security-relevant accesses in the operating system.

The solution, as with programming languages (to continue the analogy), is 
to develop higher-level abstractions to hide the underlying complexity.  
Good progress has already been made in this area, and more is expected.

I certainly don't think the solution is to start out by ignoring the 
underlying complexity.



- James
-- 
James Morris
<jmorris@namei.org>
