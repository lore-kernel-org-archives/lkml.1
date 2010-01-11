Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234Ab0AKBu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0AKBu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896Ab0AKBu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:50:27 -0500
Received: from smtp107.prem.mail.sp1.yahoo.com ([98.136.44.62]:36171 "HELO
	smtp107.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751387Ab0AKBu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:50:26 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: ACH5y9EVM1nfFHTDaR5hRjcFBa_IiU1zq88CjEY.sOhdNctEGwFuW4ZDOdG062JP6DzpwMJs9HTwTiBr5NskT3mBE3USqH_PkeRWqgSlkM9iMSeG12uafWyh9EBUfcz7oQnTmnEPr.f3itm8XRWCXSw7KEdi3mbjt6tyb3YYKohn08g2FDNL3joGNpgAOB7yk7AuzSu0MEGdWyeiprLX58tAGT1TgrDrCDlPGt62wLqxs1q.fimc4Y5wkTaj3gPRPwPi_qsr0dYYDbbFMpi0TBvSyvqVcwTzwuVlpAl2AaI4UAO00ArX0w--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B4A83E0.9000207@schaufler-ca.com>
Date: Sun, 10 Jan 2010 17:50:24 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: Michael Stone <michael@laptop.org>, Kyle Moffett <kyle@moffetthome.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Machek <pavel@ucw.cz>, Al Viro <viro@zeniv.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
References: <f73f7ab81001101418x3b3f8652j256f6311ad6244c5@mail.gmail.com> 	<20100110230839.GB3825@heat> <3e8340491001101541tc776ad9r887be13393bcb7fd@mail.gmail.com>
In-Reply-To: <3e8340491001101541tc776ad9r887be13393bcb7fd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan wrote:
> On Sun, Jan 10, 2010 at 6:08 PM, Michael Stone <michael@laptop.org> wrote:
>   
>> Paraphrasing Kyle:
>>
>>     
>>> Suppose there exist PAM modules which lazily fork background processes.
>>> Now
>>> assume that one of those PAM modules is hooked from /etc/pam.d/su, that
>>> the
>>> module fails closed when the network is unavailable, and that Mallory wins
>>> the race to start the daemon. Boom.
>>>       
>> I'm not disagreeing that there are configurations of programs, written for
>> kernels without disablenetwork, which cease to be correct on kernels that
>> provide it. However, all this says to me is that people who need to use
>> those
>> configurations probably shouldn't use disablenetwork. (Or that we haven't
>> found
>> exactly the right semantics for disablenetwork yet.)
>>     
>
> With the semantics given, the choice for using disablenetwork is given
> to the unprivileged process, not to the administrator or privileged
> process, so people using these configurations have no choice - the
> malicious local user can just use it anyway.
>
> I still think requiring a drop of suid abilities would be best - if
> the suid process wants to run in a no-network environment it can still
> disablenetwork itself.
>
>   

Stop. If you can count on the program to use the mechanisms you've
described correctly you can count on it to use exec, socket, and
bind correctly. You're only trading one set of behaviors for another.


