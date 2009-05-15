Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZEOLao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZEOLao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 07:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZEOLag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 07:30:36 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:59523 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZEOLaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 07:30:35 -0400
Message-ID: <4A0D525B.5070509@emcraft.com>
Date: Fri, 15 May 2009 15:30:35 +0400
From: Sergei Poselenov <sposelenov@emcraft.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 'make headers_check' failed to install headers to arbitrary location
References: <4A0C3BFB.1010305@emcraft.com> <200905141854.37869.arnd@arndb.de>
In-Reply-To: <200905141854.37869.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

Thanks, but it doesn't help. The same error.

This is actually not a perl error, but the shell's
passing a list of files with added $(install) prefix.

Regards,
Sergei

Arnd Bergmann wrote:
> On Thursday 14 May 2009, Sergei Poselenov wrote:
>>    CHECK   include/linux/tc_ematch (4 files)
>>    CHECK   include/linux/usb (8 files)
>> make[2]: execvp: /bin/sh: Argument list too long
>> make[2]: *** 
> 
> Can you try this patch?
> 
> 	Arnd <><
> 
> --- a/scripts/Makefile.headersinst
> +++ b/scripts/Makefile.headersinst
> @@ -54,8 +54,8 @@ quiet_cmd_remove = REMOVE  $(unwanted)
>        cmd_remove = rm -f $(unwanted-file)
>  
>  quiet_cmd_check = CHECK   $(printdir) ($(words $(all-files)) files)
> -      cmd_check = $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) \
> -                  $(addprefix $(install)/, $(all-files));           \
> +      cmd_check = echo $(addprefix $(install)/, $(all-files)) | \
> +		  xargs $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) ; \
>  	          touch $@
>  
>  PHONY += __headersinst __headerscheck
