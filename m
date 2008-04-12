Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYDLSgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYDLSgC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbYDLSfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:35:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58996 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbYDLSfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:35:51 -0400
Date: Sat, 12 Apr 2008 19:35:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: sukadev@us.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, serue@us.ibm.com, matthltc@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] Helper patches for PTY namespaces
Message-ID: <20080412183514.GO9785@ZenIV.linux.org.uk>
References: <20080412172933.GA19295@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080412172933.GA19295@us.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 10:29:33AM -0700, sukadev@us.ibm.com wrote:
> 
> Some simple helper patches to enable implementation of multiple PTY
> (or device) namespaces.
> 
> 	[PATCH 1/4]: Propagate error code from devpts_pty_new
> 	[PATCH 2/4]: Factor out PTY index allocation
> 	[PATCH 3/4]: Move devpts globals into init_pts_ns
> 	[PATCH 3/4]: Enable multiple mounts of /dev/pts
> 
> This patchset is based on earlier versions developed by Serge Hallyn
> and Matt Helsley.

*boggle*

Care to explain how that "namespace" is different from devpts instance?
IOW, why the devil do you guys ignore Occam's Razor?

Frankly, this nonsense has gone far enough; I can buy the need to compensate
for shitty APIs (sockets, non-fs-based-IPC, etc.), but devpts *is* *a*
*fucking* *filesystem*.  Already.  And as such it's already present in
normal, real, we-really-shouldn't-have-any-other-if-not-for-ancient-stupidity
namespace.

Why not simply allow independent instances of devpts and be done with that?
