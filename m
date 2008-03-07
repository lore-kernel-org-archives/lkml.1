Return-Path: <linux-kernel-owner+w=401wt.eu-S1764121AbYCGBn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764121AbYCGBn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 20:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYCGBnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 20:43:17 -0500
Received: from namei.org ([69.55.235.186]:52742 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753124AbYCGBnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 20:43:16 -0500
Date: Fri, 7 Mar 2008 12:42:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Paul Moore <paul.moore@hp.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH -v8b -rc3] Security: Introduce security= boot parameter
In-Reply-To: <20080306160910.GA10319@ubuntu>
Message-ID: <Xine.LNX.4.64.0803071218400.25703@us.intercode.com.au>
References: <20080306121913.GA8506@ubuntu> <Xine.LNX.4.64.0803070025440.16767@us.intercode.com.au>
 <1865922a0803060632kb63405fj3d255472fb2e555f@mail.gmail.com>
 <Xine.LNX.4.64.0803070159280.8501@us.intercode.com.au> <20080306160910.GA10319@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Ahmed S. Darwish wrote:

> + * Each LSM must pass this method before registering its own operations
> + * to avoid security registration races. This method may also be used
> + * to check if your LSM is currently loaded.

The 2nd sentence is no longer correct in general, as the function can only 
be called during init.  See a fixup patch below.

Otherwise, looks good!

Acked-by: James Morris <jmorris@namei.org>

I've applied the patch and a comment fixup to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git#next

commit d6bb3bacedb68aa41ea7598e0cf1bef33cebbcc9
Author: James Morris <jmorris@namei.org>
Date:   Fri Mar 7 12:23:49 2008 +1100

    security: fix up documentation for security_module_enable
    
    security_module_enable() can only be called during kernel init.
    
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/security/security.c b/security/security.c
index 4377b00..8aa2f54 100644
--- a/security/security.c
+++ b/security/security.c
@@ -83,7 +83,7 @@ __setup("security=", choose_lsm);
  *
  * Each LSM must pass this method before registering its own operations
  * to avoid security registration races. This method may also be used
- * to check if your LSM is currently loaded.
+ * to check if your LSM is currently loaded during kernel initialization.
  *
  * Return true if:
  *     -The passed LSM is the one chosen by user at boot time,




-- 
James Morris
<jmorris@namei.org>
