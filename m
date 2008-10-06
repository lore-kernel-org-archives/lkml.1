Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYJFQzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYJFQzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYJFQz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:55:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53056 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYJFQz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:55:26 -0400
Date: Mon, 6 Oct 2008 11:54:46 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Valdis.Kletnieks@vt.edu, Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
Message-ID: <20081006165446.GA733@us.ibm.com>
References: <20080930154553.GA29249@us.ibm.com> <48E2E17C.3040108@schaufler-ca.com> <62704.1222837526@turing-police.cc.vt.edu> <48E33397.1030709@nttdata.co.jp> <20081001211507.GA28377@us.ibm.com> <48E45672.5030606@nttdata.co.jp> <20081002133949.GC11150@us.ibm.com> <48E5BDAB.3010107@nttdata.co.jp> <20081003130937.GF9651@us.ibm.com> <48E975A7.2050000@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E975A7.2050000@nttdata.co.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> Serge E. Hallyn wrote:
> > Why can't you just clear the value during security_inode_foo()?
> We need a new hook for clearing the value since security_inode_*() 
> are not always called after security_path_*() .

Heh, obviously you're right :)

So I'd recommend floating your security_path_clear() patch with a clear
description about the DAC-before-MAC property which you are maintaining.
Someone may come up with a better overall solution, but we're unlikely
to hear it until you try to push your patch.

-serge

> > Note I'm seeing this as a way for Tomoyo to temporarily (maybe) work
> > around the mis-placement of the security_path_foo() hooks.  I don't want
> > to add security_path_clear() hooks to "legitimize" the workaround.  I'd
> > rather Tomoyo and Apparmor folks keep looking for a better way to get
> > real DAC-before-MAC.
> Hmm, I can understand your opinion. The best way for AppArmor and 
> TOMOYO is to pass vfsmount to vfs_*() and security_inode_*() . This 
> approach has no DAC-before-MAC problem. However, it is clearly 
> opposed by Al because of layering. So, we are going forward 
> security_path_*() approach, which Al advised us.
> 
> Since vfsmount is only available outside vfs_*() (and vfs_*() perform 
> DAC), we cannot conceive another place now... Where do you think the 
> right place to introduce security_path_*() hooks is?
> 
> Regards,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
