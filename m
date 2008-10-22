Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYJVO1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYJVO1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYJVO1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:27:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53494 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbYJVO1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:27:13 -0400
Date: Wed, 22 Oct 2008 09:14:30 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-audit@redhat.com, viro@zeniv.linux.org.uk, sgrubb@redhat.com
Subject: Re: [PATCH 3/4] AUDIT: audit when fcaps increase the permitted or
	inheritable capabilities
Message-ID: <20081022141430.GB21612@us.ibm.com>
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com> <20081020222612.3895.6710.stgit@paris.rdu.redhat.com> <48FD6E49.6060104@kernel.org> <20081021191625.GA4657@us.ibm.com> <48FF21BF.9090509@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF21BF.9090509@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> [s/viro@...ok/viro@...uk/]
> 
> Serge E. Hallyn wrote:
> >> Logging execve()s where there is only an increase in capabilities seems
> >> wrong to me. To me it seems equally important to log any event where an
> >> execve() yields pP != 0.
> > 
> > True.
> > 
> > ... except if (!issecure(SECURE_NOROOT) && uid==0) I guess?
> > 
> > And then it also might be interesting in the case where
> > (!issecure(SECURE_NOROOT) && uid==0) and pP is not full.
> 
> I guess so, although this seems like a case of being interested in a
> (unusual) non-privileged execve().

I'm not sure what you mean - but this can only happen if bits are taken
out of the capability bounding set, right?

> >>>  	rc = bprm_caps_from_vfs_caps(&vcaps, bprm);
> >>>  
> >>> +	audit_log_bprm_fcaps(bprm, &vcaps);
> >>> +
> >> When rc != 0, the execve() will fail. Is it appropriate to log in this case?
> > 
> > It might fail because fP contains bits not in pP', right?  That's
> > probably interesting to auditors.
> 
> In which case, how is the fact it didn't execute captured in the audit log?

I assume as a FAIL?  (Not sure of the exact wording in the logs)

-serge
