Return-Path: <linux-kernel-owner+w=401wt.eu-S1422725AbXBURrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422725AbXBURrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422730AbXBURrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:47:22 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:53260 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422725AbXBURrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:47:22 -0500
Date: Wed, 21 Feb 2007 18:46:33 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Greg KH <greg@kroah.com>
cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: securityfs_create_dir strange comment
In-Reply-To: <20070221172949.GA16029@kroah.com>
Message-ID: <Pine.LNX.4.61.0702211840140.12039@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0702181642060.28890@yvahk01.tjqt.qr>
 <20070220211849.GA3416@vino.hallyn.com> <20070220222652.GB21696@kroah.com>
 <Pine.LNX.4.61.0702210042140.7132@yvahk01.tjqt.qr> <20070221040526.GA8207@kroah.com>
 <Pine.LNX.4.61.0702211805450.12039@yvahk01.tjqt.qr> <20070221172949.GA16029@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

>> >Try this instead:
>> >	if (!de)
>> >		return -ENOMEM;
>> >	if ((IS_ERR(de)) && (PTR_ERR(de) != -ENODEV))
>> >		return PTR_ERR(de);
>> >	return 0;
>> >
>> >That should cover everything properly, right?
>> 
>> In case memory could not be allocated, why does not securityfs_*() return
>> ERR_PTR(-ENOMEM) then? (I think, that's the quintessential question after
>> all. And thanks for giving an example what to do in the ENODEV case.)
>
>Actually, in reading the code (which might have helped in the first
>place), we can never return NULL if securityfs is enabled.

So we're back to the confusing comment ;-)

>So you can just drop that first check entirely.
>
>Which makes me wonder, it might be easier to just return NULL if
>securityfs is not enabled in the kernel, as long as no one checks that
>improperly...

I have actually had a look into the tree who even uses securityfs.
The most prominent case are LSMs. They need CONFIG_SECURITY=y anyway,
so securityfs is always enabled for those. What remains seems to be
tpm_bios.c.


Jan
-- 
