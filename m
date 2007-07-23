Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbXGWMKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbXGWMKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbXGWMKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:10:13 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:55253 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbXGWMKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=cBnn8D7XmM02HCfMe38I2HTgEBVKI50q/KyzoOtvhe/BFcIKTuoJmmschyV1Hze+Y43Yjyw8e5axCbL7iCi72ZsROd8y92mOlSN7K8LkKw+iXgorehVjLCRPyryNWQJp+E6P+jtDJsI+tFfkrNQsuow7PJF0lH4WZm5I6Noe/bY=
Message-ID: <46A49A0A.4070506@googlemail.com>
Date: Mon, 23 Jul 2007 14:07:38 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix fbcon - 'map_override' defined but not used warning
References: <46A38486.70903@googlemail.com> <1185171524.5046.2.camel@daplas>
In-Reply-To: <1185171524.5046.2.camel@daplas>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> On Sun, 2007-07-22 at 18:23 +0200, Gabriel C wrote:
>> Hi,
>>
>> I got this warning on current git:
>>
>> ...
>>
>> drivers/video/console/fbcon.c:130: warning: 'map_override' defined but not used
>>
>> ...
>>
>> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
>>
>> ---
>>
>> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
>> index decfdc8..60a14de 100644
>> --- a/drivers/video/console/fbcon.c
>> +++ b/drivers/video/console/fbcon.c
>> @@ -127,7 +127,9 @@ static int last_fb_vc = MAX_NR_CONSOLES - 1;
>>  static int fbcon_is_default = 1; 
>>  static int fbcon_has_exited;
>>  static int primary_device = -1;
>> +#ifndef MODULE
> 
> Disrecard my other comment. This should be
> 
> #ifdef CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY

You really sure ? 

With that you have an compile error with !MODULE && !CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY

You are using that code checking !MODULE and you check !map_override with CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY

...

#ifndef MODULE
static int __init fb_console_setup(char *this_opt)
{
...
		      con2fb_map_boot[i] =
                                                (options[j++]-'0') % FB_MAX;
                                }

                                map_override = 1; <-- should die here with !CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY && !MODULE
                        }

                        return 1;
                }

...

#endif


> 
>>  static int map_override;
>> +#endif
>>  
>>  /* font data */
>>  static char fontname[40];
> 
> Tony
> 
> 

Gabriel
