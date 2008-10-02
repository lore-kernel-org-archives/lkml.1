Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbYJBNk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbYJBNk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYJBNkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:40:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58001 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYJBNkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:40:12 -0400
Date: Thu, 2 Oct 2008 08:39:49 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Valdis.Kletnieks@vt.edu, Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
Message-ID: <20081002133949.GC11150@us.ibm.com>
References: <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp> <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp> <20080930154553.GA29249@us.ibm.com> <48E2E17C.3040108@schaufler-ca.com> <62704.1222837526@turing-police.cc.vt.edu> <48E33397.1030709@nttdata.co.jp> <20081001211507.GA28377@us.ibm.com> <48E45672.5030606@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E45672.5030606@nttdata.co.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> Serge E. Hallyn wrote:
> > I suppose you could do something like define both _path and _inode,
> > save away your result from the _path hook but always return 0, there,
> > then if you'd saved off an error and you make it to the _inode hook,
> > return the error there...
> You mean do MAC checks in security_path_*() and return error code of 
> security_path_*() in security_inode_*()? Then, method for passing the 
> error code to security_inode_*() is a problem.
> 
> It was possible to store the error code into current->security->
> something. But now, it is impossible to store the error code into 
> current->cred->security->something because current->cred is shared by 
> multiple processes. To solve this problem, we everytime need to copy 
> current->cred in security_path_*() and we need a new hook called just 
> after returning from vfs_* (like mnt_drop_write()) for clearing the 
> error code. 
> 
> Or, another way is to pass the error code as a vfs_*() parameter.
> 
> What do you think these approaches?

Just keep your own hash table.

-serge
