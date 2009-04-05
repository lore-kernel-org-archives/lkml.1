Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZDED43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZDED43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 23:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZDED4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 23:56:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53172 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZDED4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 23:56:18 -0400
Date: Sat, 4 Apr 2009 22:59:15 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] don't raise all privs on setuid-root file with fE set
	(v2)
Message-ID: <20090405035914.GA26896@hallyn.com>
References: <20090402234714.GA2220@us.ibm.com> <49D7A11A.8010801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D7A11A.8010801@kernel.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Serge E. Hallyn wrote:
> > Distributions face a backward compatibility problem with starting to use
> > file capabilities.  For instance, removing setuid root from ping and
> > doing setcap cap_net_raw=pe means that booting with an older kernel
> > or one compiled without file capabilities means ping won't work for
> > non-root users.
> > 
> > In order to replace the setuid root bit on a capability-unaware
> > program, one has to set the effective, or legacy, file capability,
> > which makes the capability effective immediately.  This patch
> > uses the legacy bit as a queue to not automatically add full
> 
> s/queue/cue/

Oops.

(I wonder whether this is worth resending?)

> > privilege to a setuid-root program.
> > 
> > So, with this patch, an ordinary setuid-root program will run with
> > privilege.  But if /bin/ping has both setuid-root and cap_net_raw in
> > fP and fE, then ping (when run by non-root user) will not run
> > with only cap_net_raw.
> 
> Acked-by: Andrew G. Morgan <morgan@kernel.org>

thanks,
-serge
