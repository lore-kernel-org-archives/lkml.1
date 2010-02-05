Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932Ab0BEWVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:21:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36303 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791Ab0BEWVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:21:43 -0500
To: Sven Joachim <svenjoac@gmx.de>
Cc: hadi@cyberus.ca, Randolf Pohl <randolf.pohl@gmx.de>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [46/74] net: restore ip source validation
References: <20100205143441.280460@gmx.net> <1265381514.5661.1.camel@bigi>
	<87wryr4qkk.fsf@turtle.gmx.de> <m1mxzn8mj5.fsf@fess.ebiederm.org>
	<87pr4jxuzl.fsf@turtle.gmx.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 05 Feb 2010 14:21:16 -0800
In-Reply-To: <87pr4jxuzl.fsf@turtle.gmx.de> (Sven Joachim's message of "Fri\, 05 Feb 2010 21\:55\:58 +0100")
Message-ID: <m1iqabe337.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven Joachim <svenjoac@gmx.de> writes:

> On 2010-02-05 21:17 +0100, Eric W. Biederman wrote:
>
>> Bah.  That DEVINET_SYSCTL_ENTRY requires having a binary sysctl
>> assigned, just to use as an index.
>>
>> Which of course trips over all of the fine checks in sysctl_check.c to
>> keep people from assigning new binary sysctls by accident.
>>
>> That is the only place in the kernel where he have that problem, I wonder
>> how much work it will be to finish untangling.
>
> Isn't that already done in 2.6.33, looking at commit 83ac201b ?  Forgive
> my ignorance, I am a layman.

In 2.6.33 the enumeration in sysctl.h still serves double duty as an index
into a per network device bitmap and as the binary sysctl number.  You are
correct that the rest of the binary sysctl code is decoupled in 2.6.33.

In 2.6.32 the implementation is also still coupled and that difference is
what caused problems for the backport.

I just wince whenever I noticed we have touched sysctl.h.

Eric

