Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYDLSz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYDLSz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYDLSzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:55:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbYDLSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:55:17 -0400
Message-ID: <48010583.3020403@zytor.com>
Date: Sat, 12 Apr 2008 11:54:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>, serue@us.ibm.com,
       matthltc@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Multiple instances of devpts
References: <20080412172933.GA19295@us.ibm.com> <20080412183514.GO9785@ZenIV.linux.org.uk>
In-Reply-To: <20080412183514.GO9785@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> 
> *boggle*
> 
> Care to explain how that "namespace" is different from devpts instance?
> IOW, why the devil do you guys ignore Occam's Razor?
> 
> Frankly, this nonsense has gone far enough; I can buy the need to compensate
> for shitty APIs (sockets, non-fs-based-IPC, etc.), but devpts *is* *a*
> *fucking* *filesystem*.  Already.  And as such it's already present in
> normal, real, we-really-shouldn't-have-any-other-if-not-for-ancient-stupidity
> namespace.
> 
> Why not simply allow independent instances of devpts and be done with that?

In particular:

/dev/ptmx can be a symlink ptmx -> pts/ptmx, and we add a ptmx instance 
inside the devpts filesystem.  Each devpts filesystem is responsible for 
its own pool of ptys, with own numbering, etc.

This does mean that entries in /dev/pts are more than just plain device 
nodes, which they are now (you can cp -a a device node from /dev/pts 
into another filesystem and it will still "just work"), but I doubt this 
actually matters to anyone.  If anyone cares, now I guess would be a 
good time to speak up.

	-hpa
