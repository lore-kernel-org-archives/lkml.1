Return-Path: <linux-kernel-owner+w=401wt.eu-S1751470AbZH2BdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbZH2BdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 21:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZH2BdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 21:33:06 -0400
Received: from mail-yw0-f200.google.com ([209.85.211.200]:39642 "EHLO
	mail-yw0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZH2BdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 21:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=suNZf/E+FpJGws1/luhp61MsVIjHlQqYppTs+lBpMP+oXKNtj7LVd+NVwlZvnCvlh7
         KRgQZ09O84b9uRPDr6jjT7ao+W2da+KI2rv9X4S3VamPxy3ddJgAwg0Id8wL4fxGEsHA
         qKcr4m2vF9p5b6PdIcSoTHYDu+Jkc8Mvcio+E=
Message-ID: <4A98854E.9020302@gmail.com>
Date: Fri, 28 Aug 2009 19:33:02 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ext2/3: document conditions when reliable operation is possible
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net>
In-Reply-To: <200903121413.04434.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2009 01:13 PM, Rob Landley wrote:
>> +* write caching is disabled. ext2 does not know how to issue barriers
>> +  as of 2.6.28. hdparm -W0 disables it on SATA disks.
>
> And here we're talking about ext2.  Does neither one know about write
> barriers, or does this just apply to ext2?  (What about ext4?)
>
> Also I remember a historical problem that not all disks honor write barriers,
> because actual data integrity makes for horrible benchmark numbers.  Dunno how
> current that is with SATA, Alan Cox would probably know.

I've heard rumors of disks that claim to support cache flushes but 
really just ignore them, but have never heard any specifics of model 
numbers, etc. which are known to do this, so it may just be legend. If 
we do have such knowledge then we should really be blacklisting those 
drives and warning the user that we can't ensure data integrity. (Even 
powering down the system would be unsafe in this case.)
