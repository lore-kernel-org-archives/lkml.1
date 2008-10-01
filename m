Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYJAIYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYJAIYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYJAIX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:23:56 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:36355 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYJAIXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:23:55 -0400
Message-ID: <48E33397.1030709@nttdata.co.jp>
Date: Wed, 01 Oct 2008 17:23:51 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
References: <20080924090317.359685535@nttdata.co.jp> <20080924090338.407746083@nttdata.co.jp> <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp> <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp> <20080930154553.GA29249@us.ibm.com>            <48E2E17C.3040108@schaufler-ca.com> <62704.1222837526@turing-police.cc.vt.edu>
In-Reply-To: <62704.1222837526@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2008 08:23:52.0643 (UTC) FILETIME=[09B57930:01C9239F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 30 Sep 2008 19:33:32 PDT, Casey Schaufler said:
>> I have always believed that MAC should come first, then DAC, because
>> MAC may care if you can see the mode bits. The current DAC before MAC
>> is an artifact of the desire for the LSM to behave cleanly as a
>> strictly additional mechanism. From an ideal security perspective
>> MAC should be first, but the pragmatic DAC first isn't going to cause
>> too much grief. If Tomoyo wants to do what I think is the right thing,
>> well, it's OK with me.
> I'm OK with the MAC going first as well
Current implementation is as follows.
- security_path_*: MAC before DAC
- security_inode_*: DAC before MAC
I can understand Casey and Valdis' MAC first approach from the ideal 
security perspective. However, from the pragmatic perspective, we 
prefer DAC before MAC approach as SELinux does. This approach doesn't 
change error code returned to callers if requested access is denied 
by DAC.

Regards,

