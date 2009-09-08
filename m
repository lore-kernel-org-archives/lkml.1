Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbZIHQsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbZIHQsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZIHQsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:48:13 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36520 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbZIHQsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:48:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gWKcKDgFkSvOnnvOhLV9nd+GKhoyPWqUe0envv3QnMftaDNVO4GxaiYyN969U5XLvJ
         oiICt9BsB4PRhwWY+RVlaQqBvek1SQ8Wm3923rSM45Nyle4WUpqEK26K/hQSo0yKx/03
         OllGfcQAePkOGHrEkHuPWY6DTAwvyJQ865Je4=
Message-ID: <4AA68AC1.2000705@gmail.com>
Date: Wed, 09 Sep 2009 00:48:01 +0800
From: Xiangfu Liu <xiangfu.z@gmail.com>
Organization: openmobilefree.net (PI project)
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: matrix_keypad driver, Combination keys
References: <4A819D39.2040006@qi-hardware.com> <20090812024620.E4E10526EC9@mailhub.coreip.homeip.net> <4A9AA392.4060301@gmail.com> <20090901021034.6117F526EA5@mailhub.coreip.homeip.net> <4AA474DC.9010509@gmail.com>
In-Reply-To: <4AA474DC.9010509@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiangfu Liu wrote:
> Hi Dmitry
> Dmitry Torokhov wrote:
>> Hi,
>> Historically our KEY_* definitions did not include defines for symbols
>> like '@' because they do not have a dedicated key but rather being
>> produced as a combination of a primary key + modifier; the mapping is
>> done either in console driver or in X.
>>
>> Looking at the picture of the device that you provided it appears that
>> your device does not have a dedicated '@' key so it should work in the
>> same fashion as above.
>>
> 
> since we don't have X now. I google about this. I don't know how to 
> modify the console driver. can you tell me which file I need look 
> into? thanks.
> 
> I found an another method. we use busybox in rootfs. the busybox have 
> command [dumpkmap] [loadkmap] [showkey],
> 
> -----------
> in host system run :
> /usr/bin/dumpkeys > normal_keymap
> /usr/bin/loadkeys funky_mini_keyboard_keymap
> /usr/bin/busybox dumpkmap > funky_mini_keyboard_keymap.bin
> /usr/bin/loadkeys normal_keymap
> 
> then in target system run
> "loadkmap funky_mini_keyboard_keymap.bin"
> -----------
> 
> in our device have a two special keys
> [RED UP POINT] keycode is 94
> [QI] keycode is 93
> 

can I modify this function matrix_keyboard.c:103
static void matrix_keypad_scan(struct work_struct *work)
to detect the combination keys?
like:
1. if press the compose keys [RED UP POINT] just record
2. if next press the 'w'. will report '@' to OS.

if it's possible. how to report '@' to OS. 
I saw the source code is always report the keycode.

thanks for help
-- 
Xiangfu Liu
Email: xiangfu at qi-hardware dot com
Web: http://www.qi-hardware.com
