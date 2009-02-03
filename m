Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbZBCVSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbZBCVSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZBCVSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:18:22 -0500
Received: from [84.77.67.98] ([84.77.67.98]:4568 "EHLO ventoso.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZBCVSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:18:21 -0500
Message-ID: <4988B494.1020503@ventoso.org>
Date: Tue, 03 Feb 2009 22:18:12 +0100
From: Luca Olivetti <luca@ventoso.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090114)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
 paging request at ff100000
References: <20090203172836.GA6964@elte.hu> <1233685361.5903.131.camel@desktop> <20090203193029.GA13726@elte.hu> <4988ABEE.6020703@ventoso.org>
In-Reply-To: <4988ABEE.6020703@ventoso.org>
Content-Type: multipart/mixed;
 boundary="------------020305010704070703060904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020305010704070703060904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

En/na Luca Olivetti ha escrit:
> En/na Ingo Molnar ha escrit:
>> * Daniel Walker <dwalker@fifo99.com> wrote:
>>
>>> On Tue, 2009-02-03 at 18:28 +0100, Ingo Molnar wrote:
>>>> FYI, -tip qa keeps triggering this bootup crash occasionally, ever 
>>>> since June 2008 when a DVB merge brought in this new driver:
>>> It looks like it could be a config problem.. The crash happens around 
>>> these two symbol "af9005_rc_keys", and "af9005_rc_keys_size" , and 
>>> they are both defined inside af9005-remote.c different from where the 
>>> init functions is lcoated .. af9005-remote.c needs a special config 
>>> CONFIG_DVB_USB_AF9005_REMOTE to get compiled which you have disabled..
>>
>> ok - but it shouldnt crash, obviously.
> 
> Did you try my suggestion I sent the past December 26th?

The attached patch should be better (sorry it's bzipped, but thunderbird 
crashed three times when I tried to attach it raw), since it initializes 
the remote before calling usb_register.
Could you give it a try?

What I don't know is, if usb_register fails (so making module_init
fail), will module_exit be called nevertheless?
If not, those symbols would be kept and should be freed in module_init
in case usb_register fails.

Bye
-- 
Luca



--------------020305010704070703060904
Content-Type: application/x-bzip;
 name="no_remote_crash.patch.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="no_remote_crash.patch.bz2"

QlpoOTFBWSZTWYBYxHAAAOTfgAAwU3//ukECBAC/r/96QAG13dtrswlJR6J6m1NqaBmpkyNA
AGhoBJBKaYpk2gj1NMhoANAGagipNBR6bKI3pJ6nqNAAAAaBKnqKeptTygAaA0AAAAOV2s24
kIiUQO8Nx1tg5DbYbLSZbRDqyHLRGM3lVJDowEG060UVU2cfCvKvQ5zVrnVO+Im55tZExT1o
SbjDQMiZRCIMcLk8Qh5NbeNmgFgTQzm25dqsChC1zZmTIi/rBxCEW8zOSBzKVGo0HhapiGGj
brJJJzVDQrqPRVxWZ8tstmdUYDTkLMdVCKKGMJUnKzgJ1JNE+DGZgROI1CoJznFwH0rokA+X
r0tbd8N8fNwOp8izYfRjebnBg21LY+LLxEVD7xz+OYdc7lylhYebYZIjc1/3+FCC5Zgzs0Ch
kQczE0tom4CJl3qXkeIJuGMCRG42DFyJ9CwchMF4BqSOHjcK0SE1JAly+xQxErJZa1wxGgxl
ZkW9igwaZ7B3ud+DJdxKJV6NK2FaWoYtThIjosCir1A6TqS+WvTwh0Z7CpccFO1eVoyfsmTb
hmmvUyNDAawuDWH+LuSKcKEhALGI4A==
--------------020305010704070703060904--
