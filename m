Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbYEMUoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbYEMUoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbYEMUoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:44:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:39941 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758273AbYEMUn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HpjANIbcCYV+/6rXsxDu6xb3AYp0+rjluse5Ta656DbiQCLDUmHJtBsfkWj4fhJEcRGpfuIzB5sT1gZpskNnN+D9Rz7YHPvxRR6mpTtD2SCHr1ddIBBLzj8fPojJw/1//PaQ70FbOm8KkYAVVON+ZbndraqpKgXBTLJfE0klZSA=
Message-ID: <4829FD74.2020702@gmail.com>
Date: Tue, 13 May 2008 22:43:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: request_firmware() gives build failures
References: <17728.1210628903@vena.lwn.net>
In-Reply-To: <17728.1210628903@vena.lwn.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2008 11:48 PM, Jonathan Corbet wrote:
> In any case, setting CONFIG_FW_LOADER=y makes the problem go away.  I'm
> not good enough at kconfig to make that happen magically; putting in
> "select FW_LOADER" doesn't seem to be enough.

Maybe I overlooked something, but I fix that way the same issue today. What 
exactly doesn't work with select FW_LOADER?

$ grep FW ../a/moxa/.config
CONFIG_FW_LOADER=m
$ grep INTELL ../a/moxa/.config
CONFIG_MOXA_INTELLIO=y
$ vim drivers/char/Kconfig
<add select FW_LOADER to MOXA_INTELLIO>
$ make O=../a/moxa/ SUBARCH=i386 drivers/char/moxa.o
   GEN     /home/l/latest/a/moxa/Makefile
scripts/kconfig/conf -s arch/x86/Kconfig
#
# configuration written to .config
#
fatal: cannot describe '18f96f01977fa1905fd0f8f8522698cc97287022'
   Using /home/l/latest/xxx as source for kernel
   GEN     /home/l/latest/a/moxa/Makefile
   CHK     include/linux/version.h
   CHK     include/linux/utsrelease.h
   CALL    /home/l/latest/xxx/scripts/checksyscalls.sh
   CC      drivers/char/moxa.o
$ grep FW ../a/moxa/.config
CONFIG_FW_LOADER=y
