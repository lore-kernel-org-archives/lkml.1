Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab0BQQKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:10:31 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59204 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0BQQK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:10:28 -0500
To: Cong Wang <amwang@redhat.com>
Cc: Octavian Purdila <opurdila@ixiacom.com>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [net-next PATCH v4 0/3] net: reserve ports for applications using fixed port
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com>
	<201002162151.04861.opurdila@ixiacom.com>
	<m1mxz93pw2.fsf@fess.ebiederm.org>
	<201002162322.13101.opurdila@ixiacom.com>
	<4B7C11D4.1080309@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Feb 2010 08:10:21 -0800
In-Reply-To: <4B7C11D4.1080309@redhat.com> (Cong Wang's message of "Wed\, 17 Feb 2010 23\:57\:08 +0800")
Message-ID: <m1ljer3ksy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <amwang@redhat.com> writes:

> Octavian Purdila wrote:
>> On Tuesday 16 February 2010 22:08:13 you wrote:
>>>> Something like bellow?
>>>>
>>>> # set bits 8080 and 1666
>>>> $echo 8080 1666-1666 > /proc
>>>>
>>>> #reset bit 1666
>>>> $echo 8080 > /proc
>>>>
>>>> #reset whole bitmap
>>>> $echo > /proc
>>> Yes. So something like that.
>>>
>>> I think I would use commas instead of spaces as that is more traditional.
>
>
> Why this is better than the current version?
>
> For the single port case, currently we use:
>
> echo +8080 > /xxxx #set
> echo -8080 > /xxxx #clear
>
> Now we will use:
>
> echo 8080 > /xxxx #set
> echo 8080 > /xxxx #clear

No.

> I don't think the latter is better...
>
> For the multi-port case, yes, we should accept 'echo 8080,10000 >/xxxx'.

What I was envisioning was:

echo 8080 > /xxx # set the bitmap to 8080
echo 8080,10000 > /xxx # add 10000 to the bitmap
echo 8080 > /xxxx # remove 10000 from the bitmap.

That is when you set it you enter the entire set every time, treating
the entire set as a single value.

Eric
