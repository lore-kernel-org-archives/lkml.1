Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0CBWBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:01:42 -0500
Received: from tundra.namei.org ([65.99.196.166]:55496 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab0CBWBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:01:40 -0500
Date: Wed, 3 Mar 2010 09:01:22 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Joel Becker <Joel.Becker@oracle.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>,
       a.gruenbacher@computer.org
Subject: Re: [PATCH 2/2] ocfs2: ensure trusted xattrs are not returned to
 unprivileged users via listxattr
In-Reply-To: <20100302092946.GA21180@mail.oracle.com>
Message-ID: <alpine.LRH.2.00.1003030855400.14492@tundra.namei.org>
References: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org> <alpine.LRH.2.00.1003021901530.1594@tundra.namei.org> <20100302092946.GA21180@mail.oracle.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010, Joel Becker wrote:

> On Tue, Mar 02, 2010 at 07:02:22PM +1100, James Morris wrote:
> > Ensure that trusted xattrs are not returned to unprivileged users
> > via listxattr, in keeping with several other implmentations, such
> > as ext3.
> > 
> > Signed-off-by: James Morris <jmorris@namei.org>
> 
> If this is the standard expectation, why not lift it up into the vfs?

The VFS doesn't know what's in the listxattr list.  When using generic 
xattr handlers for synthetic xattrs, it's easy to determine the xattr 
namespace (each namespace has a handler), although on-disk xattrs need to 
be read from disk to determine if they're in the trusted namespace.

The VFS could possibly modify the listxattr results after the fact, 
although it's very ugly, and it would not be able to correctly handle size 
probes, where the VFS only sees a total size value from the FS.


- James
-- 
James Morris
<jmorris@namei.org>
