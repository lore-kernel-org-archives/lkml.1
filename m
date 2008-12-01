Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYLAUDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYLAUDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYLAUDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:03:35 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:49596 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbYLAUDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:03:34 -0500
Subject: Re: [TOMOYO #13 (mmotm 2008-11-19-02-19) 01/11] Introduce
	security_path_clear() hook.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       Crispin Cowan <crispin@crispincowan.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20081120112727.557697893@I-love.SAKURA.ne.jp>
References: <20081120112543.799450455@I-love.SAKURA.ne.jp>
	 <20081120112727.557697893@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 01 Dec 2008 15:00:12 -0500
Message-Id: <1228161612.18720.211.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 20:25 +0900, Tetsuo Handa wrote:
> plain text document attachment (introduce-security_path_clear.patch)
> To perform DAC performed in vfs_foo() before MAC, we let security_path_foo()
> save a result into our own hash table and return 0, and let security_inode_foo()
> return the saved result. Since security_inode_foo() is not always called after
> security_path_foo(), we need security_path_clear() to clear the hash table.

This seems very fragile and unmaintainable to me.  The fact that you
even need a security_path_clear() hook suggests that something is wrong
with the other security_path* hooks. I'd suggest that you explicitly
pass the result of the security_path* hooks down to the security_inode*
hooks instead.  What do others think?

-- 
Stephen Smalley
National Security Agency

