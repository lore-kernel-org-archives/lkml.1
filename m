Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYJFCTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYJFCTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 22:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYJFCTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 22:19:43 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:64806 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYJFCTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 22:19:42 -0400
Message-ID: <48E975A7.2050000@nttdata.co.jp>
Date: Mon, 06 Oct 2008 11:19:19 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Valdis.Kletnieks@vt.edu, Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
References: <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp> <20080930154553.GA29249@us.ibm.com> <48E2E17C.3040108@schaufler-ca.com> <62704.1222837526@turing-police.cc.vt.edu> <48E33397.1030709@nttdata.co.jp> <20081001211507.GA28377@us.ibm.com> <48E45672.5030606@nttdata.co.jp> <20081002133949.GC11150@us.ibm.com> <48E5BDAB.3010107@nttdata.co.jp> <20081003130937.GF9651@us.ibm.com>
In-Reply-To: <20081003130937.GF9651@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2008 02:19:37.0993 (UTC) FILETIME=[FB634790:01C92759]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Why can't you just clear the value during security_inode_foo()?
We need a new hook for clearing the value since security_inode_*() 
are not always called after security_path_*() .

> Note I'm seeing this as a way for Tomoyo to temporarily (maybe) work
> around the mis-placement of the security_path_foo() hooks.  I don't want
> to add security_path_clear() hooks to "legitimize" the workaround.  I'd
> rather Tomoyo and Apparmor folks keep looking for a better way to get
> real DAC-before-MAC.
Hmm, I can understand your opinion. The best way for AppArmor and 
TOMOYO is to pass vfsmount to vfs_*() and security_inode_*() . This 
approach has no DAC-before-MAC problem. However, it is clearly 
opposed by Al because of layering. So, we are going forward 
security_path_*() approach, which Al advised us.

Since vfsmount is only available outside vfs_*() (and vfs_*() perform 
DAC), we cannot conceive another place now... Where do you think the 
right place to introduce security_path_*() hooks is?

Regards,

