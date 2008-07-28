Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbYG1Vj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbYG1Vj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbYG1VjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:39:16 -0400
Received: from namei.org ([69.55.235.186]:35798 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753780AbYG1VjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:39:14 -0400
Date: Tue, 29 Jul 2008 07:38:17 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Thomas Meyer <thomas@m3y3r.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org
Subject: Re: BUG at security/selinux/avc.c:883 (was: Re: linux-next: Tree
 for July 17: early crash on x86-64)
In-Reply-To: <1217266358.20373.54.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Xine.LNX.4.64.0807290736440.30242@us.intercode.com.au>
References: <20080718012842.690b8346.sfr@canb.auug.org.au> 
 <a4423d670807180652y352e66lfe04d2b33d2ed176@mail.gmail.com> 
 <20080719035231.GU28946@ZenIV.linux.org.uk>  <200807192042.06988.rjw@sisk.pl>
  <Xine.LNX.4.64.0807200553380.22632@us.intercode.com.au> 
 <1216546973.3217.6.camel@dhcppc2>  <20080720121559.GV28946@ZenIV.linux.org.uk>
 <1217266358.20373.54.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008, Stephen Smalley wrote:

> SELinux needs MAY_APPEND to be passed down to the security hook.
> Otherwise, we get permission denials when only append permission is
> granted by policy even if the opening process specified O_APPEND.
> Shows up as a regression in the ltp selinux testsuite, fixed by
> this patch.
> 
> Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>

Applied to  
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#hotfixes


Al, holler if you want to push this through your tree.


---

 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index a7b0a0b..b91e973 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -274,7 +274,7 @@ int inode_permission(struct inode *inode, int mask)
                return retval;
 
        return security_inode_permission(inode,
-                       mask & (MAY_READ|MAY_WRITE|MAY_EXEC));
+                       mask & (MAY_READ|MAY_WRITE|MAY_EXEC|MAY_APPEND));
 }
 
 /**



- James
-- 
James Morris
<jmorris@namei.org>
