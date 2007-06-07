Return-Path: <linux-kernel-owner+w=401wt.eu-S1765675AbXFGQfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765675AbXFGQfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbXFGQey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:34:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757834AbXFGQex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:34:53 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: casey@schaufler-ca.com
Subject: Re: [PATCH] Audit: Add TTY input auditing
Date: Thu, 7 Jun 2007 12:31:43 -0400
User-Agent: KMail/1.9.4
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Miloslav Trmac <mitr@redhat.com>,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Alexander Viro <aviro@redhat.com>
References: <817517.5859.qm@web36605.mail.mud.yahoo.com>
In-Reply-To: <817517.5859.qm@web36605.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071231.43843.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007 11:42, Casey Schaufler wrote:
> > tools like rootsh, but that is too easy to detect and defeat. And then it
> > does not put its data into the audit system where its correlated with
> > other system events.
>
> The evaluation teams that I have worked with (OrangeBook and CC)
> as well as their technical advisory groups have always been clear
> that keyboard logging is not an appropriate mechanism for security
> audit logging. There is insufficient correlation between what is
> typed and security relevent actions for keyboard (or mouse event)
> logging to meet the audit requirements.

Ok, this is a sample set of requirements we are trying to meet:

Implement automated audit trails for all system components to reconstruct the 
following events:
  All actions taken by any individual with root or administrative privileges

If we do not get commands typed at a prompt, we have to audit by execve. 
Auditing execve for uid = 0 produces millions of events since that includes 
daemons. If we get clever and restrict auditing to events for root uid and 
auid >= 500, we still wind up with millions of events because of shell 
scripts. 

People in control of some of these security targets said to me that auditing 
by execve cannot be the solution, because the audit trail becomes too big, 
unwieldy, full of irrelavent events, and not easily analysed. So, that 
approach does not work for people either.

Casey, so what approach would you take to meet the requirement?

> You have to log what happened.

Which can be done by auditing for execution of specific apps or watching 
access to certain files. So, I don't see tty auditing as something that 
replaces other auditing, it allows us to form a better picture of what 
happened to the system.

> Logging what was requested is insufficient and logging what was
> typed, which may or may not have resulted in an actual request is
> not helpful to meeting security audit requirements.

I would disagree. Its helpful to complete the picture of what's happening on 
the system.

-Steve
