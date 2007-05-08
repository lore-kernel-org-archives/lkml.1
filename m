Return-Path: <linux-kernel-owner+w=401wt.eu-S1032131AbXEHU6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032131AbXEHU6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032121AbXEHU6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:58:31 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:40608 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032120AbXEHU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:58:29 -0400
Date: Tue, 8 May 2007 13:58:26 -0700
From: Andreas Dilger <adilger@clusterfs.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>, jeffschroeder@computer.org,
       Chris Wright <chrisw@sous-sol.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH 2/2] file capabilities: accomodate >32 bit capabilities
Message-ID: <20070508205826.GH6375@schatzie.adilger.int>
Mail-Followup-To: "Serge E. Hallyn" <serue@us.ibm.com>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	James Morris <jmorris@namei.org>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Andrew Morton <akpm@linux-foundation.org>,
	jeffschroeder@computer.org, Chris Wright <chrisw@sous-sol.org>,
	Karl MacMillan <kmacmillan@mentalrootkit.com>,
	KaiGai Kohei <kaigai@kaigai.gr.jp>
References: <20070508191548.GA29913@sergelap.austin.ibm.com> <20070508191704.GC29913@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508191704.GC29913@sergelap.austin.ibm.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 08, 2007  14:17 -0500, Serge E. Hallyn wrote:
> As the capability set changes and distributions start tagging
> binaries with capabilities, we would like for running an older
> kernel to not necessarily make those binaries unusable.
> 
> 	(0. Enable the CONFIG_SECURITY_FS_CAPABILITIES option
> 	   when CONFIG_SECURITY=n.)
> 	(1. Rename CONFIG_SECURITY_FS_CAPABILITIES to
> 	   CONFIG_SECURITY_FILE_CAPABILITIES)
> 	2. Introduce CONFIG_SECURITY_FILE_CAPABILITIES_STRICTXATTR
> 	   which, when set, prevents loading binaries with capabilities
> 	   set which the kernel doesn't know about.  When not set,
> 	   such capabilities run, ignoring the unknown caps.
> 	3. To accomodate 64-bit caps, specify that capabilities are
> 	   stored as
> 	   	u32 version; u32 eff0; u32 perm0; u32 inh0;
> 		u32 eff1; u32 perm1; u32 inh1; (etc)

Have you considered how such capabilities will be used in the future?
One of the important use cases I can see today is the ability to
split the heavily-overloaded e.g. CAP_SYS_ADMIN into much more fine
grained attributes.

What we definitely do NOT want to happen is an application that needs
priviledged access (e.g. e2fsck, mount) to stop running because the
new capabilities _would_ have been granted by the new kernel and are
not by the old kernel and STRICTXATTR is used.

To me it would seem that having extra capabilities on an old kernel
is relatively harmless if the old kernel doesn't know what they are.
It's like having a key to a door that you don't know where it is.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

