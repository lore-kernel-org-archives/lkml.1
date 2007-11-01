Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbXKARZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbXKARZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbXKARZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:25:08 -0400
Received: from mail.suse.de ([195.135.220.2]:47220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbXKARZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:25:06 -0400
Date: Thu, 1 Nov 2007 10:23:24 -0700
From: Tony Jones <tonyj@suse.de>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] audit: clear thread flag for new children
Message-ID: <20071101172324.GA3938@suse.de>
References: <20071026204228.GA1519@suse.de> <200710291804.31784.sgrubb@redhat.com> <20071029231529.GB15210@suse.de> <200711011033.53265.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711011033.53265.sgrubb@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 10:33:52AM -0400, Steve Grubb wrote:
> On Monday 29 October 2007 07:15:30 pm Tony Jones wrote:
> > On Mon, Oct 29, 2007 at 06:04:31PM -0400, Steve Grubb wrote:
> > > So when audit is re-enabled, how do you make that task auditable?
> >
> > No idea. How do you do it currently? HINT: current->audit_context == NULL
> > for these tasks.  If !audit_enabled, then audit_alloc() is not going to
> > allocate an audit_context for the task.
> 
> We are looking into this - at one time it did. Someone should follow up with 
> a path correcting this soon. But I doubt the audit system will work correctly 
> if the flag gets removed as there is no good way to add it again later.

So on the syscall path you're now going to something like (pseudocode):
if (unlikely(current->audit_context)) {audit_syscall_entry()} 
else if (audit_enabled) {audit_alloc(); audit_syscall_entry()}

I agree, if this is what you want to do, then clearing the thread flag would
be a bad idea.  I'd assumed the current behaviour was by design as allocating
contexts at syscall time doesn't seem a great idea but if you need the 
functionality, you need the functionality.

Tony
