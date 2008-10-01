Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYJACdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYJACdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 22:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYJACdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 22:33:43 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:31195 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753477AbYJACdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 22:33:42 -0400
X-YMail-OSG: yXSCLtEVM1kXLlnBt2ikwM1ZReLxL6KGcQBZ5a2KG_b9mDO34BKd4dRGgiILoshqx5g0WqPhdOVDtV44O8WuJB3VzO7aXZFa_tKpUKE5y3uAalj_oM06c3cPPl4_iEbF8FX0ziXRKBlUFVPRJ3GHKtHh4TnV608xjC5z8MMtW6hJhzrsXA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48E2E17C.3040108@schaufler-ca.com>
Date: Tue, 30 Sep 2008 19:33:32 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
References: <20080924090317.359685535@nttdata.co.jp> <20080924090338.407746083@nttdata.co.jp> <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp> <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp> <20080930154553.GA29249@us.ibm.com>
In-Reply-To: <20080930154553.GA29249@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
>   
>> Serge E. Hallyn wrote:
>>     
>>> Unfortunately I think that is a shortcoming in the security_path_*
>>> patchset.  Unfortunate bc that is going to be a pain to work out.
>>>       
>> Thanks for your constructive and tough suggestion. ;-)
>>
>>     
>>> So for starters,
>>> both vfs_mknod and vfs_create do may_create, so just pull that
>>> into the callers.
>>>       
>> Do you mean that we should move DAC code to all the caller of vfs_* ? 
>>     
>
> That's not reasonable, is it.
>
> The rule thus far has been 'DAC before MAC'.  Question to all:  do we
> insist on keeping it that way?
>
> If the answer is yes, then the security_path_hooks patch is inherently
> wrong.
>
> If the answer is no, then Kentaro doesn't need to resort to this
> ugliness to try and get may_delete() called before his MAC code, only to
> have may_delete() called a second time from the vfs_* functions.
>
> -serge
>
>   

I have always believed that MAC should come first, then DAC, because
MAC may care if you can see the mode bits. The current DAC before MAC
is an artifact of the desire for the LSM to behave cleanly as a
strictly additional mechanism. From an ideal security perspective
MAC should be first, but the pragmatic DAC first isn't going to cause
too much grief. If Tomoyo wants to do what I think is the right thing,
well, it's OK with me.



