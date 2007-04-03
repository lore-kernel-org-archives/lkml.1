Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbXDCEF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbXDCEF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 00:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXDCEF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 00:05:59 -0400
Received: from relay4.usu.ru ([194.226.235.39]:39704 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbXDCEF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 00:05:58 -0400
Message-ID: <4611D2C6.3090102@ums.usu.ru>
Date: Tue, 03 Apr 2007 10:06:30 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] vt: Expose system-wide UTF-8 default setting via sysfs
References: <4611ACCD.5000305@gmail.com>
In-Reply-To: <4611ACCD.5000305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> Create a variable, default_utf8, that defines the system-wide default UTF-8
> setting.  This variable can be altered via sysfs. If the variable is properly
> set, this should mimimize breakage of UTF-8 encoded consoles when doing a
> reset or echo -e '\033c' and of newly opened/allocated consoles.
> 
> This is based from patches by Jan Engelhardt and Paul LeoNerd Evans.
> 
> Signed-off-by: Antonino Daplas <adaplas@gmail.com>
> ---
>> I think you're missing the whole point of console reset.  Its purpose is 
>> to force the console into a known-good state.  The fewer pieces of state 
>> it leaves unset, the better.  To some degree it's less important what 
>> that state actually is.
> 
> Okay, you convinced me. Hopefully this is acceptable to all parties.
> 
> Andrew,
> 
> If everybody agrees, can you drop the previous patch I sent to you, and use
> this instead?
> 
> Tony
> +static int default_utf8;
> +module_param(default_utf8, int, S_IRUGO | S_IWUSR);

Module parameter without description and documentation? Yes, I understand 
that it is impossible to make vt a module. How about adding a line to 
Documentation/kernel-parameters.txt?

Other than that, the patch looks like a useful change.

-- 
Alexander E. Patrakov
