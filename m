Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbYKJOq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbYKJOq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYKJOqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:46:49 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34382 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbYKJOqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:46:48 -0500
Date: Mon, 10 Nov 2008 08:46:32 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, sgrubb@redhat.com,
       morgan@kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH -v3 3/5] AUDIT: output permitted and inheritable fcaps
	in PATH records
Message-ID: <20081110144632.GB11561@us.ibm.com>
References: <20081107151355.9977.47852.stgit@paris.rdu.redhat.com> <20081107151406.9977.3167.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107151406.9977.3167.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> This patch will print cap_permitted and cap_inheritable data in the PATH
> records of any file that has file capabilities set.  Files which do not
> have fcaps set will not have different PATH records.
> 
> An example audit record if you run:
> setcap "cap_net_admin+pie" /bin/bash
> /bin/bash
> 
> type=SYSCALL msg=audit(1225741937.363:230): arch=c000003e syscall=59 success=yes exit=0 a0=2119230 a1=210da30 a2=20ee290 a3=8 items=2 ppid=2149 pid=2923 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3 comm="ping" exe="/bin/ping" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
> type=EXECVE msg=audit(1225741937.363:230): argc=2 a0="ping" a1="www.google.com"
> type=CWD msg=audit(1225741937.363:230):  cwd="/root"
> type=PATH msg=audit(1225741937.363:230): item=0 name="/bin/ping" inode=49256 dev=fd:00 mode=0104755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:ping_exec_t:s0 cap_fp=0000000000002000 cap_fi=0000000000002000 cap_fe=1 cap_fver=2
> type=PATH msg=audit(1225741937.363:230): item=1 name=(null) inode=507915 dev=fd:00 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:ld_so_t:s0
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

...
> +struct audit_cap_data {
> +	kernel_cap_t		permitted;
> +	kernel_cap_t		inheritable;
> +	union {
> +		unsigned int	fE;
> +		kernel_cap_t	effective;
> +	};
> +};

To help future readers, it might be helpful to have a comment here to
explain that fE is used when it describes a file cap, and effective when
it describes a process cap.  Maybe that's obvious enough, I'm not sure.

thanks,
-serge
