Return-Path: <linux-kernel-owner+w=401wt.eu-S1751233AbZJWCMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbZJWCMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 22:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbZJWCMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 22:12:43 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:61352 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZJWCMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 22:12:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VPpb8WbtYoCzmSjaSr4ub7KOMk9mrm55XjbqpjSlq5582uTx4jyHd43oGjKOlUYQZs
         ddlSOQk8OcHteF+e0yfwTEzMi9745HgUIR8Mp9NqV91P7spCQY/G2C78GQroD7a9dTqP
         /K+vavn+L8MmKpH56HSDLcfCF0tbUUBzwaTwE=
Message-ID: <4AE11106.1060303@gmail.com>
Date: Thu, 22 Oct 2009 19:12:22 -0700
From: "Eugene T. Bordenkircher" <eugebo@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
CC: jeffrey.t.kersher@intel.com, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com, peter.p.waskiewicz.jr@intel.com,
       john.ronciak@intel.com
Subject: Re: Problem with MDI/MDI-X auto-switching in E100 driver
References: <20091022190908.GA9002@rhlx01.hs-esslingen.de>
In-Reply-To: <20091022190908.GA9002@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> bad devel, bad! Ought to have CC'd some other guys and me ;)
> (just happened to stumble on it by accident)

I'm not sure what you mean by 'other guys' but let's try a few people out of 
the MAINTAINERS, file as well as yourself, rather than the contact information 
in the header of the file :)

>> It seems a better solution to this is to trust the eeprom's configuration
>> rather than override it.  Am I missing something or does this sound
>> reasonable?
> 
> I don't have much actual experience with various e100 versions,
> so I cannot confirm it, but if something like this gets implemented,
> then it's perhaps best to restrict the possibly more dangerous
> "trust eeprom" reverted logic to your chip version only.

> Or is the "without magnetics" feature independent of particular chip
> versions? Then of course that wouldn't help ;)

I'm a software guy, but I've had our hardware guys try to explain it to me. 
Forgive me if this doesn't make any sense to someone who knows hardware.  As I 
understand it, the 'magnetics' is how it gets hooked up post Phy, so 
theoretically the magnetic-less implementation can occur for almost any chip 
and is not isolated to just ours (82551IT, which I didn't mention before). So I 
believe it's a wider problem.  According to the afore mentioned App Note.  Auto 
-switching is not possible when the phy is connected 'without the magnetics' so 
  this feature should be turned off.  We turned it off in the configuration 
eeprom, but the e100 driver is turning it back on.

We've also discovered that with the feature on in a device that does have the 
magnetics, it's causing problems with certain switches that also implement 
auto-switching, most notably Netgear's FS108.  They both attempt to auto switch 
and for some reason they end up getting into a state where one is in MDI mode 
and the other is in MDI-X. In that case, it would be nice to be able to force 
it off.

The 'force on' that the driver does seems unnecessary since the feature is 
configurable via the eeprom, but I'm not versed on all chip variants the e100 
driver supports which is why I'm here looking for a bit of knowledge and help.
