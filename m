Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab0CNFfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 00:35:25 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:48426 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0CNFfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 00:35:23 -0500
Date: Sat, 13 Mar 2010 23:35:21 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: mtk.manpages@gmail.com
Cc: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       SELinux <selinux@tycho.nsa.gov>, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Kees Cook <kees.cook@canonical.com>, Andrew Morgan <morgan@kernel.org>,
       "Christopher J. PeBenito" <cpebenito@tresys.com>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH] Define CAP_SYSLOG
Message-ID: <20100314053521.GA12410@us.ibm.com>
References: <20100312205537.GA1091@us.ibm.com>
 <cfd18e0f1003132118y21bd71band2d07ae85c8d4c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cfd18e0f1003132118y21bd71band2d07ae85c8d4c9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Kerrisk (mtk.manpages@googlemail.com):
> > There is one downside to this patch:  If some site or distro currently
> > has syslogd/whatever running as a non-root user with cap_sys_admin+pe,
> > then it will need to be changed to run with cap_syslog+pe.  I don't
> > know if there are such sites, or if that concern means we should take
> > a different approach to introducing this change, or simply refuse this
> > change.
> 
> *If* this is a problem, would the way to address it not be to permit
> syslog if the caller has *either* CAP_SYS_ADMIN or CAP_SYSLOG? (The
> only weakness I see in this idea is that it fails to lighten the
> hugely overlaoded CAP_SYS_ADMIN.)

Which becomes a very big weakness because it won't allow a
container to be started with cap_sys_admin but not cap_syslog
in its capability bounding set.

So, if it is deemed a problem, then the alternative will be to
introduce a syslog namespace.  Container setup can then create
a new syslog namespace, and can no longer read or clear the
host's syslog.

thanks,
-serge
