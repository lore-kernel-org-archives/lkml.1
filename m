Return-Path: <linux-kernel-owner+w=401wt.eu-S1761316AbYEXTb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316AbYEXTb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 15:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYEXTbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 15:31:51 -0400
Received: from senator.holtmann.net ([87.106.208.187]:60299 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYEXTbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 15:31:51 -0400
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
Message-Id: <79373BC9-13F5-45BE-8D51-527F70D00094@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1211656999.540.16.camel@pmac.infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sat, 24 May 2008 21:31:45 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211550374.28967.10.camel@pmac.infradead.org> <20080523164108.GA31545@uranus.ravnborg.org> <1211640377.540.14.camel@pmac.infradead.org> <20080524152214.GA12582@uranus.ravnborg.org> <1211642706.31212.85.camel@shinybook.infradead.org> <1211643245.31212.88.camel@shinybook.infradead.org> <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org> <1211656999.540.16.camel@pmac.infradead.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>>>> Playing with it now. I fixed the mkdir thing by including $ 
>>>> (objtree)
>>>> in the target.
>>>
>>> Here's what I have (on top of the git tree) now. I just need to sort
>>> out
>>> the clean/mrproper behaviour -- and possibly should rename the korg
>>> firmware to firmware/korg/k1212.c_shipped?
>>
>> so using "/" within the name parameter for request_firmware() is
>> actually forbidden. I know that some driver authers think it is a  
>> good
>> idea, but it is not.
>>
>> I am actually working on a patch to make request_firmware() fail/warn
>> when the name has a "/" in it.
>>
>> You don't need to consider any deep nesting of firmware file names.  
>> It
>> was never meant to be used like this.
>
> Hm. Is there any fundamental reason why we should forbid this? It does
> seem to make sense to let people use the namespace for it.

I explained this a couple of times. The request_firmware() is an  
abstract mechanism that can request a firmware file. The location of  
the firmware file is up to the userspace. The kernel requests a  
particular file and that is it. All namespacing has to be done by the  
firmware helper script (nowadays udev). That the current  
implementation of the firmware helper maps the filename 1:1 to a file  
under /lib/firmware/ just works, but doesn't have to work all the  
time. It is not the agreed contract between kernel and userspace.

If you wanna do namespacing then you have to do it within the firmware  
helper script. For example the helper script could look for /lib/ 
firmware/<driver>/<filename> instead of /lib/firmware/<filename>.

Regards

Marcel

