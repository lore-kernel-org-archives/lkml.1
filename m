Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbYBTWRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbYBTWRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYBTWRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:17:35 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:58140 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1750985AbYBTWRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:17:34 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Thu, 21 Feb 2008 09:17:02 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 4/9]
Message-ID: <20080220221702.GE2169@tull.net>
References: <20080219140609.GA26619@tull.net> <20080219143855.GB27352@tull.net> <4760.1203478930@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4760.1203478930@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 10:42:10PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 20 Feb 2008 01:38:55 +1100, Nick Andrew said:
> > +	  AVC refers to Access Vector Cache, a subsystem used by SELinux
> > +	  to improve performance of the security checking by caching
> > +	  previous access decisions.
> 
> This paragraph can be dropped, as the reasons that SELinux denial messages
> are tagged with 'avc' are mostly historical.   If you want to expand on anything
> in here, explain that 'AVC' messages are interesting because they indicate
> some sort of security rule denial.

Ok, if AVC is incidental then I don't need to mention it, and so don't
need to define the acronym.

> So - if you don't enable auditing,
> your security messages end up in the kernel syslog.  If you enable auditing,
> they end up in the audit logs.  Explaining *that* clearly would be a lot
> more useful than explaining what avc originally stood for.. ;)

How about this. I tried to explain what happens to audit messages.

        bool "Auditing support"
        depends on NET
        help
-         Enable auditing infrastructure that can be used with another
-         kernel subsystem, such as SELinux (which requires this for
-         logging of avc messages output).  Does not do system-call
-         auditing without CONFIG_AUDITSYSCALL.
+         Enable an auditing infrastructure that can be used with another
+         kernel subsystem, such as Security-Enhanced Linux (SELinux),
+         which requires this option for logging of security related
+         messages.
+
+         With this option, the kernel can use netlink to pass audit
+         messages to an audit daemon process. Otherwise, audit messages
+         are logged to syslog.
+
+         See <http://www.nsa.gov/selinux/> for more information
+         on Security-Enhanced Linux.
+
+         CONFIG_AUDITSYSCALL (see below) is also required for
+         system-call auditing.
+
+         If unsure, say N.

I'm puzzled about "end up in the kernel syslog". Looking at include/linux/audit.h
it seems that they go nowhere:

#ifdef CONFIG_AUDIT
  [...]
#else
#define audit_log(c,g,t,f,...) do { ; } while (0)
#define audit_log_start(c,g,t) ({ NULL; })
#define audit_log_vformat(b,f,a) do { ; } while (0)
#define audit_log_format(b,f,...) do { ; } while (0)
#define audit_log_end(b) do { ; } while (0)
#define audit_log_hex(a,b,l) do { ; } while (0)
#define audit_log_untrustedstring(a,s) do { ; } while (0)
#define audit_log_n_untrustedstring(a,n,s) do { ; } while (0)
#define audit_log_d_path(b, p, d) do { ; } while (0)
#define audit_enabled 0
#endif

So it looks like if CONFIG_AUDIT is not defined then audit messages are
ignored. Syslog is used by kernel/audit.c when there is an audit
failure, which seems to be mainly if the userspace audit daemon is not
running.

Nick.
