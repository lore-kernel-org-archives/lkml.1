Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbZBDPt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbZBDPt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZBDPts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:49:48 -0500
Received: from [84.77.67.98] ([84.77.67.98]:4158 "EHLO ventoso.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbZBDPts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:49:48 -0500
Message-ID: <4989B913.1020702@ventoso.org>
Date: Wed, 04 Feb 2009 16:49:39 +0100
From: Luca Olivetti <luca@ventoso.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
 paging request at ff100000
References: <20090203172836.GA6964@elte.hu>	 <1233685361.5903.131.camel@desktop> <20090203193029.GA13726@elte.hu>	 <4988ABEE.6020703@ventoso.org> <1233710080.15119.37.camel@desktop>	 <4989ABA8.8010807@ventoso.org> <1233760607.15119.85.camel@desktop>
In-Reply-To: <1233760607.15119.85.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

En/na Daniel Walker ha escrit:

>> Doesn't symbol_request return a NULL in such a case?
>> At the time I didn't try the above configuration 
>> (CONFIG_DVB_USB_AF9005_REMOTE=n), but removed the compiled 
>> dvb-usb-af9005-remote.ko, and all was well (i.e. the symbol_request 
>> returned NULL and the remote handling was disabled).
> 
> I'm not sure what symbol request returns when CONFIG_MODULES=n .. Since
> it basically drops symbol_request() into a macro , 

Take the following with a grain of salt, since I'm not well versed in C 
(and I'm not interested) but it seems that the macro, if 
CONFIG_MODULES=n, transforms it into a weak symbol reference

> and you have externs
> for all these functions 

No, I havent: the source file isn't compiled, so those symbols are 
unavailable to the linker.
The only reference I could find (well, I haven't searched that much) on 
the expected behaviour of the linker when a weak attribute is not found 
is this:

http://software.intel.com/en-us/articles/software-convention-models-using-elf-visibility-attributes/

"# STB_WEAK. A weak symbol behaves as does a global symbol, with a few 
differences. If there are both a weak and a global definition of a name, 
the global definition takes precedence and any weak definitions are 
ignored. The Linker will not extract archive members to resolve 
undefined weak symbols. It is not an error to have unresolved weak 
references; unresolved weak symbols have the value zero. "

So it should work without your patch.

Bye

-- 
Luca

