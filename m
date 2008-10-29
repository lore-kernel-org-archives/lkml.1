Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYJ2V66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYJ2V66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYJ2V6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:58:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46526 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782AbYJ2V6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:58:49 -0400
Subject: Re: [PATCH 3/4] AUDIT: audit when fcaps increase the permitted or
 inheritable capabilities
From: Eric Paris <eparis@redhat.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-audit@redhat.com, sgrubb@redhat.com, viro@ZenIV.linux.org.uk,
       sgrubb@redhat.com
In-Reply-To: <48FFFA07.3060707@kernel.org>
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com>
	 <20081020222612.3895.6710.stgit@paris.rdu.redhat.com>
	 <48FD6E49.6060104@kernel.org> <20081021191625.GA4657@us.ibm.com>
	 <48FF21BF.9090509@kernel.org> <20081022141430.GB21612@us.ibm.com>
	 <48FFFA07.3060707@kernel.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 17:58:39 -0400
Message-Id: <1225317519.23736.60.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 21:13 -0700, Andrew G. Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge E. Hallyn wrote:
> >>> ... except if (!issecure(SECURE_NOROOT) && uid==0) I guess?
> >>>
> >>> And then it also might be interesting in the case where
> >>> (!issecure(SECURE_NOROOT) && uid==0) and pP is not full.
> >> I guess so, although this seems like a case of being interested in a
> >> (unusual) non-privileged execve().
> > 
> > I'm not sure what you mean - but this can only happen if bits are taken
> > out of the capability bounding set, right?
> 
> Yes, it can happen as you say.
> 
> This is a case of an unprivileged uid==0 execution. Since we don't
> appear to want to audit other non-privileged execve()s, its not clear to
> me that this one deserves attention.

So what did you two agree on for when to collect fcaps type information?
Any time bprm->cap_post_exec_permitted is non-zero?

> >>>>>  	rc = bprm_caps_from_vfs_caps(&vcaps, bprm);
> >>>>>  
> >>>>> +	audit_log_bprm_fcaps(bprm, &vcaps);
> >>>>> +
> >>>> When rc != 0, the execve() will fail. Is it appropriate to log in this case?
> >>> It might fail because fP contains bits not in pP', right?  That's
> >>> probably interesting to auditors.
> >> In which case, how is the fact it didn't execute captured in the audit log?
> > 
> > I assume as a FAIL?  (Not sure of the exact wording in the logs)
> 
> OK. As long as its clearly identified as a failure and the logs are not
> misleading - making it look like the execve() succeeded with privilege -
> then I'm not as concerned.

The syscall record (rather than this auxilary fcaps record) will
indicate that the syscall failed.  it says something like success=no.

