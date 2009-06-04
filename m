Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZFDHYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZFDHYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZFDHYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:24:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755086AbZFDHYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:24:14 -0400
Date: Thu, 4 Jun 2009 00:23:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console: make blank timeout value a boot option
Message-Id: <20090604002325.5b1284de.akpm@linux-foundation.org>
In-Reply-To: <1243953993-18608-1-git-send-email-daniel@caiaq.de>
References: <1243953993-18608-1-git-send-email-daniel@caiaq.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Jun 2009 16:46:33 +0200 Daniel Mack <daniel@caiaq.de> wrote:

> The console blank timer is currently hardcoded to 10*60 seconds which is
> ok for most applications but might be annoying when using the console
> for debugging and no userspace application was started to manually
> change this default behaviour.
> 
> This patch defines a core_param for the variable in charge which allows
> users to entirely disable the blank feature by setting it 0.
> 
> ...
>
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -545,6 +545,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  			console=brl,ttyS0
>  		For now, only VisioBraille is supported.
>  
> +	consoleblank=	[KNL] The console blank (screen saver) timeout in
> +			seconds. Defaults to 10*60 = 10mins. A value of 0
> +			disables the blank timer.
> +

It would be better to make this alterable at runtime, rather than at
boot time.  Perhaps another VT ioctl.

In fact I'm rather surprised that this isn't already the case.
