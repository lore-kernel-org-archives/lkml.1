Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbYCQTfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbYCQTfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbYCQTfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:35:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:21608 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbYCQTfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:35:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mUQhSQAd7+4CgSwJhzxj3W9HuBvyPxLpUC1OI7JnJOJwuIL1SfJHE3GTfi3oI9uR0ACsGNZ92swC6CcjE5WJtRHCkm1r+t8gQ5gv8hIBkUeEvsJqoHv5qyb9rLpczW0xSsdw2do9jAL78AA0GHauggEj5cRB3SWL0QxQoCVSnhc=
Message-ID: <47DEC7FC.2060003@googlemail.com>
Date: Mon, 17 Mar 2008 20:35:24 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: Linux 2.6.25-rc6
References: <alpine.LFD.1.00.0803161651350.3020@woody.linux-foundation.org>	<47DE815C.4060906@googlemail.com> <20080317193941.6f247ea1@hyperion.delvare>
In-Reply-To: <20080317193941.6f247ea1@hyperion.delvare>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Gabriel,
> 
> On Mon, 17 Mar 2008 15:34:04 +0100, Gabriel C wrote:
>> Linus Torvalds wrote:
>>
>>> Zhang, Rui (2):
>>>       thermal: fix generic thermal I/F for hwmon
>> That commit broke lmsensros here ( found by bisect ). 
>> ...
>>
>> Can't access procfs/sysfs file
>> Kernel interface access error
>> For 2.6 kernels, make sure you have mounted sysfs and libsensors
>> was compiled with sysfs support!
>>
>> ...
>>
>> Of course proc and sysfs is mounted and the lib has that support :)
> 
> This has been reported as:
> http://bugzilla.kernel.org/show_bug.cgi?id=10259
> https://bugzilla.redhat.com/show_bug.cgi?id=437637
> 
> The generic thermal zone device does something which is not
> fundamentally incorrect but that libsensors doesn't expect, and
> unfortunately libsensors was not made robust enough and dies instead of
> just ignoring the new unexpected device. libsensors 2.10.x is already
> fixed in lm-sensors' SVN [1] and a tentative patch is available for
> libsensors 3.0.x [2], however I am worried that kernel 2.6.25 will be
> released before any new version of lm-sensors so pretty much every user
> of lm-sensors will hit the problem if they upgrade to the new kernel.
> For this reason, I think we really should let the new generic thermal
> zone driver build as a module, and make it's hwmon support optional and
> disabled by default for 2.6.25 [3]. This will help mitigate the risk of
> massive breakage and complaints.
> 
> [1] http://www.lm-sensors.org/changeset/5147
> [2] https://bugzilla.redhat.com/attachment.cgi?id=298270
> [3] http://lists.lm-sensors.org/pipermail/lm-sensors/2008-March/022724.html
> 


Hmm , ok but then the situation is even worse.

Why something *known* to break _all_ existing lmsensors setups out there 
is being pushed that late in game ? 

IMO that should be just reverted from 2.6.25 and pushed again in the next merge window.

Best Regards,

Gabriel
