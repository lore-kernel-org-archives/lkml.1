Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974Ab0AKBqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab0AKBqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838Ab0AKBqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:46:53 -0500
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:22756 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750979Ab0AKBqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:46:52 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 4pG54TUVM1luAJvSL3EnrLbtRxo1To8wfRsNeuWUfdUFNpd8oSR4RfKRe2ok3KOgYhT14ZtzHt0_GeKhSV_dpxlz8pziCA3ABmSUG_St4LeNBKaRJP3s5Cx5M15gVtyZOid8xIVKlnFrcST0YyXB1AtMqNCNgfRgGBnBS._W1SNLcLhOaxiea1YtYVF_7UExEWvFzkqNAktQsPNjoHrJQEtcuWShB_sDYzRgEO4Zr2Usyl_FMFdmrtqxj3P9C8.DATi8q8CvVq7ofl17Jkc-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B4A8309.9090801@schaufler-ca.com>
Date: Sun, 10 Jan 2010 17:46:49 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: michael@laptop.org, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       andi@firstfloor.org, david@lang.hm, socketcan@hartkopp.net,
       alan@lxorguk.ukuu.org.uk, herbert@gondor.apana.org.au,
       Valdis.Kletnieks@vt.edu, bdonlan@gmail.com, zbr@ioremap.net,
       cscott@cscott.net, jmorris@namei.org, ebiederm@xmission.com,
       bernie@codewiz.org, mrs@mythic-beasts.com, randy.dunlap@oracle.com,
       xiyou.wangcong@gmail.com, sam@synack.fr, serue@us.ibm.com,
       viro@ZenIV.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
References: <20100110215848.GA26609@elf.ucw.cz>	<20100110224010.GA3825@heat> <201001111007.EAG82373.VHFQSLFOFMOOJt@I-love.SAKURA.ne.jp>
In-Reply-To: <201001111007.EAG82373.VHFQSLFOFMOOJt@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Michael Stone wrote:
>   
>> Examples of software that I want to be able to gain privileges normally include:
>>
>>    rainbow, which requires privilege in order to add new accounts to the system
>>    and in order to call setuid() but which does not require networking
>>    privileges.
>>     
>
> If the system is not using local files (i.e. /etc/passwd and /etc/shadow),
> the process who wants to add new accounts to the system might need network
> access (e.g. to LDAP server), doesn't it?
>
>   

It's much worse than that. A user that has been network disabled
who tries using ls may find that it goes looking for the network
on each name lookup and has to wait for a timeout for each. Yet
another example of why Real Users hate security features with
such passion. Then, if there are local file entries that differ
from the "official" network account values when the library
functions finally fall back on the local values you get the wrong
names for file owners. Now we've made ls slow and untrustworthy
in the name of security.


