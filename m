Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYBQNEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYBQNEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYBQNEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:04:09 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:41130 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYBQNEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:04:08 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 17/27] acer-wmi: fix section mismatch warnings
Date: Sun, 17 Feb 2008 13:03:55 +0000
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>
References: <20080217121255.GA10519@uranus.ravnborg.org> <1203250984-11285-17-git-send-email-sam@ravnborg.org>
In-Reply-To: <1203250984-11285-17-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171303.56229.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sun, 17 Feb 2008 13:05:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2008 12:22:54 Sam Ravnborg wrote:
> Fix following warnings:
> WARNING: vmlinux.o(.text+0x672615): Section mismatch in reference from the
> function acer_platform_remove() to the function
> .exit.text:acer_backlight_exit() WARNING: vmlinux.o(.devinit.text+0x1e859):
> Section mismatch in reference from the function acer_platform_probe() to
> the function .init.text:acer_led_init() WARNING:
> vmlinux.o(.devinit.text+0x1e878): Section mismatch in reference from the
> function acer_platform_probe() to the function
> .init.text:acer_backlight_init()
>
> Remove __exit annotation from acer_backlight_exit(). We cannot reference
> a __exit annotated function from non __exit functions.
>
> acer_led_init() and acer_backlight_init() where both annotated __init but
> used from a __devinit function. This would result in an oops should
> gcc drop their inlining and the module are hot plugged.
>
> Fix by annotating acer_led_init() and acer_backlight_init() __devinit.
>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

> Cc: Len Brown <len.brown@intel.com>

Len, can you apply this to acpi-test? (Unless Andrew wants to take all these 
through -mm?)

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
