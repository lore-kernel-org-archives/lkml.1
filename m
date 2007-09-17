Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbXIQI13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbXIQI13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXIQI1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:27:08 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:49553 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbXIQI1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=X4IHytnMShaHH9hykzhbwWhRfQwbkQH2AQwjz+RZWgAaqiDfZQbDzweerKEuDYMQnDHGMtcJ6PrMLYE3Fown1ZUa4O51GQIPtyUfh5R7dGvrk/x10j0w/Um/B2OdAsIAkmSC0pJAZqpnRHK/l5kLx5Fm8DYwOF6barPcZm7Q3OA=
Message-ID: <46EE0F14.8070008@gmail.com>
Date: Mon, 17 Sep 2007 07:22:28 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Robert Schwebel <r.schwebel@pengutronix.de>, Heiko Schocher <hs@denx.de>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Detlev Zundel <dzu@denx.de>
Subject: Re: SYSFS: need a noncaching read
References: <1189503798.6674.46.camel@Zeus.EmbLux> <20070912053207.GH23573@pengutronix.de> <20070912100123.GA23182@kroah.com>
In-Reply-To: <20070912100123.GA23182@kroah.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Sep 12, 2007 at 07:32:07AM +0200, Robert Schwebel wrote:
>> On Tue, Sep 11, 2007 at 11:43:17AM +0200, Heiko Schocher wrote:
>>> I have developed a device driver and use the sysFS to export some
>>> registers to userspace.
>> Uuuh, uggly. Don't do that. Device drivers are there to abstract things,
>> not to play around with registers from userspace.
>>
>>> I opened the sysFS File for one register and did some reads from this
>>> File, but I alwas becoming the same value from the register, whats not
>>> OK, because they are changing. So I found out that the sysFS caches
>>> the reads ... :-(
>> Yes, it does. What you can do is close()ing the file handle between
>> accesses, which makes it work but is slow.
> 
> Do an lseek back to 0 and then re-read, you will get called in your
> driver again.

There should be an intervening sysfs_notify() call from kernel side to
make sysfs re-populate its cache on read again.  sysfs bin files buffer
the result but don't cache the result but this again doesn't really fit
the usage case.

Thanks.

-- 
tejun

