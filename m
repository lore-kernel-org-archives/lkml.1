Return-Path: <linux-kernel-owner+w=401wt.eu-S935898AbXFGTah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935898AbXFGTah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934629AbXFGTa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:30:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764394AbXFGTa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:30:29 -0400
Message-ID: <46685C67.7000108@redhat.com>
Date: Thu, 07 Jun 2007 21:28:39 +0200
From: Miloslav Trmac <mitr@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Steve Grubb <sgrubb@redhat.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH] Audit: Add TTY input auditing
References: <442798.53194.qm@web36614.mail.mud.yahoo.com>
In-Reply-To: <442798.53194.qm@web36614.mail.mud.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler napsal(a):
>> If we do not get commands typed at a prompt, we have to audit by execve. 
> I would suggest that you'll have to do that as well so that you can tell
> the difference between typed actions like these:
> 
> # cat > /dev/null
> badprogram --badthing --everyone
> ^D
> #
> 
> # badprogram --badthing --everyone
> 
> where the same typed line is a Bad Thing in one case and completely
> irrelevent in the other.
The proposed patch audits each process separately, and includes a part
of the command name in the audit event, so it is easy to distinguish
between data entered into (cat > /dev/null) and the shell.

The command name can be faked, but the actions necessary to fake the
command name would be audited.
	Mirek
