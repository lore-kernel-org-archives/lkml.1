Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYDWTqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYDWTqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 15:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYDWTp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 15:45:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:63284 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbYDWTp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 15:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MxgWg0F8XlSmWj0PEjExhJwWWSpHIDKwNxWGiDMds9dvEXsZLMn08+3WbeUq4Q42FHaxmvUieOdcRM1OqXl1eW+Fj947uPqt5on6shP+tHEUnNDLY0kuERdHwrbiTWsHc4sVGS6WQtRNulklz7w79GJHa1aybsR+NNLlBo5AuN4=
Message-ID: <74d0deb30804231245q9326f0bq20bc52f62d5c437@mail.gmail.com>
Date: Wed, 23 Apr 2008 21:45:54 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Stephen Hemminger" <shemminger@vyatta.com>
Subject: Re: [PATCH] mfd: pasic3 driver build error
Cc: "Russell King" <rmk+kernel@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080423112223.4df31c56@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080423112223.4df31c56@extreme>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 8:22 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> Fix build failure on other platforms because this driver includes
>  registers that do not exist on other platforms.

Yeah, people[1] already[2] noticed[3]. That #include statement was
left there accidentally, sorry about that. The fix[4] is in the ARM
tree.

[1] http://lkml.org/lkml/2008/4/22/40
[2] http://lkml.org/lkml/2008/4/22/323
[3] http://lkml.org/lkml/2008/4/21/593
[4] http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=5010/1

>  Signed-off-by: Stephen Hemminger <stephen.hemminger@vyatta.com>
>
>  --- a/drivers/mfd/Kconfig       2008-04-23 11:16:06.000000000 -0700
>  +++ b/drivers/mfd/Kconfig       2008-04-23 11:16:52.000000000 -0700
>  @@ -32,6 +32,7 @@ config HTC_EGPIO
>
>   config HTC_PASIC3
>         tristate "HTC PASIC3 LED/DS1WM chip support"
>  +       depends on ARCH_PXA
>         help
>           This core driver provides register access for the LED/DS1WM
>           chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
>
