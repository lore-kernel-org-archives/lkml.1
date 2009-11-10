Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZKJOHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZKJOHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZKJOHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:07:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36413 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZKJOHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:07:36 -0500
Date: Tue, 10 Nov 2009 08:07:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-security-module@vger.kernel.org, Andrew Morgan <morgan@kernel.org>,
       Steve Grubb <sgrubb@redhat.com>, Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>
Subject: drop SECURITY_FILE_CAPABILITIES?
Message-ID: <20091110140739.GA15534@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Just a probe to see what people think.  I've seen two cases
in about the last month where software was confounded by
an assumption that prctl(PR_CAPBSET_DROP, CAP_SOMETHING)
would succeed if privileged, but not handling the fact
that SECURITY_FILE_CAPABILITIES=n means you can't do that.

Are we at the point yet where we feel we can get rid of
the SECURITY_FILE_CAPABILITIES=n case?

Note that there is a boot arg no_file_caps which prevents
file capabilities from being used if SECURITY_FILE_CAPABILITIES=y.
I think that's the case most users will care about, whereas the
remaining differences between CONFIG_SECURITY_FILE_CAPABILITIES=y
and =n are that with CONFIG_SECURITY_FILE_CAPABILITIES=y :

	(1) certain security hooks (task_setscheduler, task_setioprio, and
	task_setnice) do capability set comparisions,
	(2) it is possible to drop capabilities from the bounding set,
	(3) it is possible to set per-task securelevels,
	(4) and it is possible to add any capability to your inheritable
	set if you have CAP_SETPCAP.

Does anyone know of cases where CONFIG_SECURITY_FILE_CAPABILITIES=n
is still perceived as useful?

thanks,
-serge
