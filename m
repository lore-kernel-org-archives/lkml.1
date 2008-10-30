Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYJ3Pa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYJ3Pa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYJ3PaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:30:13 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58064 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbYJ3PaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:30:11 -0400
Date: Thu, 30 Oct 2008 10:29:40 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       jmorris@nameil.org, morgan@kernel.org, casey@schaufler-ca.com,
       esandeen@redhat.com
Subject: Re: [PATCH -v1 1/3] SECURITY: new capable_noaudit interface
Message-ID: <20081030152940.GA24853@us.ibm.com>
References: <20081029190652.31292.5901.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029190652.31292.5901.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> Add a new capable interface that will be used by systems that use audit to
> make an A or B type decision instead of a security decision.  Currently
> this is the case at least for filesystems when deciding if a process can use
> the reserved 'root' blocks and for the case of things like the oom
> algorithm determining if processes are root processes and should be less
> likely to be killed.  These types of security system requests should not be
> audited or logged since they are not really security decisions.  It would be
> possible to solve this problem like the vm_enough_memory security check did
> by creating a new LSM interface and moving all of the policy into that
> interface but proves the needlessly bloat the LSM and provide complex
> indirection.
> 
> This merely allows those decisions to be made where they belong and to not
> flood logs or printk with denials for thing that are not security decisions.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Please introduce some meaningful defines instead of passing 0 and 1.
I.e.

#define CAP_NOAUDIT 0
#define CAP_AUDIT 1

Otherwise, looks fine.

thanks,
-serge
