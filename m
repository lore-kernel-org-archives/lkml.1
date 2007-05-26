Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbXEZFV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbXEZFV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 01:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbXEZFVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 01:21:20 -0400
Received: from smtpout.mac.com ([17.250.248.173]:50311 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbXEZFVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 01:21:19 -0400
In-Reply-To: <309300.41401.qm@web36615.mail.mud.yahoo.com>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
Cc: Andreas Gruenbacher <agruen@suse.de>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Sat, 26 May 2007 01:20:50 -0400
To: casey@schaufler-ca.com
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 24, 2007, at 14:58:41, Casey Schaufler wrote:
> On Fedora zcat, gzip and gunzip are all links to the same file.  I  
> can imagine (although it is a bit of a stretch) allowing a set of  
> users access to gunzip but not gzip (or the other way around).

That is a COMPLETE straw-man argument.  I can override your "check"  
with this absolutely trivial perl code:

exec { "/usr/bin/gunzip" } "gzip", "-9", "some/file/to.gz";

Pathname-based checks are pretty fundamentally insecure.  If you want  
to protect a "name", then you should tag the "name" with security  
attributes (IE: AppArmor).  On the other hand, if you actually want  
to protect the _data_, then tagging the _name_ is flawed; tag the  
*DATA* instead.

Cheers,
Kyle Moffett

