Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYJBFF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYJBFF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 01:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYJBFFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 01:05:15 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:48099 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYJBFFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 01:05:14 -0400
Message-ID: <48E45672.5030606@nttdata.co.jp>
Date: Thu, 02 Oct 2008 14:04:50 +0900
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
References: <20080924090317.359685535@nttdata.co.jp> <20080924090338.407746083@nttdata.co.jp> <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp> <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp> <20080930154553.GA29249@us.ibm.com> <48E2E17C.3040108@schaufler-ca.com> <62704.1222837526@turing-police.cc.vt.edu> <48E33397.1030709@nttdata.co.jp> <20081001211507.GA28377@us.ibm.com>
In-Reply-To: <20081001211507.GA28377@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2008 05:05:10.0815 (UTC) FILETIME=[7228A2F0:01C9244C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> I suppose you could do something like define both _path and _inode,
> save away your result from the _path hook but always return 0, there,
> then if you'd saved off an error and you make it to the _inode hook,
> return the error there...
You mean do MAC checks in security_path_*() and return error code of 
security_path_*() in security_inode_*()? Then, method for passing the 
error code to security_inode_*() is a problem.

It was possible to store the error code into current->security->
something. But now, it is impossible to store the error code into 
current->cred->security->something because current->cred is shared by 
multiple processes. To solve this problem, we everytime need to copy 
current->cred in security_path_*() and we need a new hook called just 
after returning from vfs_* (like mnt_drop_write()) for clearing the 
error code. 

Or, another way is to pass the error code as a vfs_*() parameter.

What do you think these approaches?

Regards,

