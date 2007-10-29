Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbXJ2XRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbXJ2XRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbXJ2XRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:17:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:48066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbXJ2XRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:17:12 -0400
Date: Mon, 29 Oct 2007 16:15:30 -0700
From: Tony Jones <tonyj@suse.de>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] audit: clear thread flag for new children
Message-ID: <20071029231529.GB15210@suse.de>
References: <20071026204228.GA1519@suse.de> <200710271021.42093.sgrubb@redhat.com> <20071029172058.GA8433@suse.de> <200710291804.31784.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710291804.31784.sgrubb@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 06:04:31PM -0400, Steve Grubb wrote:

> If the child does not have the TIF_SYSCALL_AUDIT flag, it never goes into
> audit_syscall_entry. It becomes unauditable.

True but a task where current->audit_context == NULL is going to immediately
BUG out in audit_syscall_entry.  This is why the invocations of 
audit_syscall_entry() are conditional on current->audit_context.

> So when audit is re-enabled, how do you make that task auditable?

No idea. How do you do it currently? HINT: current->audit_context == NULL
for these tasks.  If !audit_enabled, then audit_alloc() is not going to 
allocate an audit_context for the task.

I'm very curious how you think one of these tasks becomes auditable later
on once audit is re-enabled,  regardless of the value of TIF_SYSCALL_AUDIT.

Tony
