Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZK3IxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZK3IxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZK3IxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:53:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:40882 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbZK3IxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:53:14 -0500
Message-ID: <4B1387EB.2090506@kernel.org>
Date: Mon, 30 Nov 2009 17:52:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Greg KH <greg@kroah.com>, Robert Hancock <hancockrwd@gmail.com>,
       Mikhail Malygin <mmalygin@ked.de>, Hans Werner <hwerner4@gmx.de>,
       Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix FailSafe
 issue?
References: <20091126164212.GA24421@sig21.net> <20091128191932.GB24048@kroah.com> <4B11886E.3030906@gmail.com> <20091128213446.GA26420@kroah.com> <20091128222203.GA369@sig21.net> <20091129001745.GA29143@kroah.com> <20091129005157.GA6487@sig21.net>
In-Reply-To: <20091129005157.GA6487@sig21.net>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2009 09:51 AM, Johannes Stezenbach wrote:
> On Sat, Nov 28, 2009 at 04:17:45PM -0800, Greg KH wrote:
>> On Sat, Nov 28, 2009 at 11:22:03PM +0100, Johannes Stezenbach wrote:
>>>
>>> BTW, at 5min after boot it is 99% guaranteed that this ATA
>>> exception will happen during the occasional fsck. That
>>> doesn't feel right.
>>
>> Well, I've never been doing a fsck at 5 minutes into boot, and neither do
>> most Windows users :)
> 
> I've been through a lot of reboots with all the testing, and
> the fsck took longer than 5min, and the ATA exception  struck.
> fsck continued after the 30 second stall and succeeded.

The timeout will happen if the C state switching happens while ATA
command is in flight so unless there's heavy IO load, it's not very
likely to hit.  Another factor is that windows uses shorter IO timeout
(I think it's 7 secs or 15, I'm not sure) so it's gonna be less
noticeable when it happens.  Hmmm.... there were talks about
shortening the timeout.  Maybe it's about time we actually do that.

Thanks.

-- 
tejun
