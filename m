Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbXFGRdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbXFGRdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXFGRdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:33:06 -0400
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:22640 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752702AbXFGRdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:33:05 -0400
X-YMail-OSG: wdmFFh0VM1kNYMxXZma1co8QL2IeJZAWjBiX3KP8cqXnd6NUjMgkQM6rpAyJ5H0jgBaU4poMWQ--
X-RocketYMMF: rancidfat
Date: Thu, 7 Jun 2007 10:33:04 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Audit: Add TTY input auditing
To: Steve Grubb <sgrubb@redhat.com>, casey@schaufler-ca.com
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Miloslav Trmac <mitr@redhat.com>,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Alexander Viro <aviro@redhat.com>
In-Reply-To: <200706071231.43843.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <442798.53194.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Steve Grubb <sgrubb@redhat.com> wrote:


> Ok, this is a sample set of requirements we are trying to meet:
> 
> Implement automated audit trails for all system components to reconstruct the
> 
> following events:
>   All actions taken by any individual with root or administrative privileges

My knee jerk response is "good luck with that". I hope you're not
planning a GUI, because tracing the mouse movements, clicks, and
window placement in order to identify what action the admin is taking
is going to be a without-a-net trick.

> If we do not get commands typed at a prompt, we have to audit by execve. 

I would suggest that you'll have to do that as well so that you can tell
the difference between typed actions like these:

# cat > /dev/null
badprogram --badthing --everyone
^D
#

# badprogram --badthing --everyone

where the same typed line is a Bad Thing in one case and completely
irrelevent in the other.

> Auditing execve for uid = 0 produces millions of events since that includes 
> daemons. If we get clever and restrict auditing to events for root uid and 
> auid >= 500, we still wind up with millions of events because of shell 
> scripts.

Yes. Your Linux system performs millions (yea, billions) of security
relevent actions in the time it takes you (well, me) to spell check an
lkml posting. Audit systems spew lots of data because there's lots of
data that is required to track who did what to whom.

> People in control of some of these security targets said to me that auditing 
> by execve cannot be the solution, because the audit trail becomes too big, 
> unwieldy, full of irrelavent events, and not easily analysed. So, that 
> approach does not work for people either.

OK. They're not willing to pay the price for the result they are asking for.

> Casey, so what approach would you take to meet the requirement?

If the requirement is that all human initiated administrative actions
be audited your only option is to seriously restrict the actions that
the human can perform by hand. This is usually accomplished by providing
an administration user interface facility as the admin shell. This shell
only invokes a tightly controlled set of commands, and audits their
parameters.

> > You have to log what happened.
> 
> Which can be done by auditing for execution of specific apps or watching 
> access to certain files. So, I don't see tty auditing as something that 
> replaces other auditing, it allows us to form a better picture of what 
> happened to the system.

Perhaps.
 
> > Logging what was requested is insufficient and logging what was
> > typed, which may or may not have resulted in an actual request is
> > not helpful to meeting security audit requirements.
> 
> I would disagree. Its helpful to complete the picture of what's happening on 
> the system.

As an adjunct to system level audit it might be helpful, but
it cannot stand on its own.


Casey Schaufler
casey@schaufler-ca.com
