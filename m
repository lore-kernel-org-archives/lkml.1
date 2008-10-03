Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbYJCNJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbYJCNJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 09:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYJCNJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 09:09:42 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50238 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYJCNJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 09:09:40 -0400
Date: Fri, 3 Oct 2008 08:09:37 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Valdis.Kletnieks@vt.edu, Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
Message-ID: <20081003130937.GF9651@us.ibm.com>
References: <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp> <20080930154553.GA29249@us.ibm.com> <48E2E17C.3040108@schaufler-ca.com> <62704.1222837526@turing-police.cc.vt.edu> <48E33397.1030709@nttdata.co.jp> <20081001211507.GA28377@us.ibm.com> <48E45672.5030606@nttdata.co.jp> <20081002133949.GC11150@us.ibm.com> <48E5BDAB.3010107@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E5BDAB.3010107@nttdata.co.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> Serge E. Hallyn wrote:
> > Just keep your own hash table.
> I see, then we want one more LSM hook for clearing the hash table 
> after returing from vfs_*().
> 
> foo() {
> 	error = security_path_foo(); /* save result in the hash table */
> 	error = vfs_foo(); /* fetch from the hash table in security_inode_*() */
> 	security_path_clear(); /* clear the hash table */
> }
> 
> Is it acceptable?

Why can't you just clear the value during security_inode_foo()?

Note I'm seeing this as a way for Tomoyo to temporarily (maybe) work
around the mis-placement of the security_path_foo() hooks.  I don't want
to add security_path_clear() hooks to "legitimize" the workaround.  I'd
rather Tomoyo and Apparmor folks keep looking for a better way to get
real DAC-before-MAC.

> Regards,
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
