Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYJCGhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYJCGhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 02:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYJCGh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 02:37:28 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:41424 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYJCGh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 02:37:27 -0400
Message-ID: <48E5BDAB.3010107@nttdata.co.jp>
Date: Fri, 03 Oct 2008 15:37:31 +0900
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
References: <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp> <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp> <20080930154553.GA29249@us.ibm.com> <48E2E17C.3040108@schaufler-ca.com> <62704.1222837526@turing-police.cc.vt.edu> <48E33397.1030709@nttdata.co.jp> <20081001211507.GA28377@us.ibm.com> <48E45672.5030606@nttdata.co.jp> <20081002133949.GC11150@us.ibm.com>
In-Reply-To: <20081002133949.GC11150@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Oct 2008 06:37:22.0735 (UTC) FILETIME=[7DDA63F0:01C92522]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Just keep your own hash table.
I see, then we want one more LSM hook for clearing the hash table 
after returing from vfs_*().

foo() {
	error = security_path_foo(); /* save result in the hash table */
	error = vfs_foo(); /* fetch from the hash table in security_inode_*() */
	security_path_clear(); /* clear the hash table */
}

Is it acceptable?

Regards,


