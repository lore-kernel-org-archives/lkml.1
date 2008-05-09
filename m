Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbYEIWeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbYEIWeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYEIWd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:33:56 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:60595 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988AbYEIWdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:33:53 -0400
Message-ID: <4824AD3C.3070506@grupopie.com>
Date: Fri, 09 May 2008 20:59:56 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
References: <20080509174148.GA22246@basil.nowhere.org> <482491D6.9030205@grupopie.com> <4824A7B6.70306@firstfloor.org>
In-Reply-To: <4824A7B6.70306@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>> ffffffff80337043 u idr_pre_get  [i2c_core]
>>> ffffc2000007573e ? DW.sched.h.920090ff.56       [i2c_core]
>> Are you compiling with CONFIG_KALLSYMS_ALL?
> 
> Yep.
> 
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> 
>> If you are, kallsyms will store all the output of "nm -n vmlinux" no
>> matter what section the symbol belongs to...
> 
> Yes and? Surely that's not correct?

That's not for me to judge, but I believe it has always been like that.

I just wanted to understand if you noticed a change in behavior (which 
is probably a bug) or if it has always been like that but you just 
noticed how ugly it is.

Maybe you also have some debug or markers configuration or something 
that is generating extra symbols to a special section that is just 
making the problem look worse now.

Anyway, I can change the way kallsyms works, but that has to be done 
with some care because there are some userspace tools that read 
/proc/kallsyms and we don't want to break those. A proper testing period 
through -mm should take care of that, though.

-- 
Paulo Marques - www.grupopie.com

"All generalizations are false."
