Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbZEKX7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbZEKX7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZEKX7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:59:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54365 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZEKX7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:59:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
Date: Tue, 12 May 2009 01:58:45 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20090508165219.469818319@chello.nl> <20090508170028.837558214@chello.nl>
In-Reply-To: <20090508170028.837558214@chello.nl>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905120158.46314.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18YWwqDp1zYhnuMrSqtZdS+XfnpJjzCwqbEz4K
 jD+XELt6Tg8tOARnt35dawJHE/QA11sbKdFrOeYdCLJuly0VT8
 OmBhEUXS5uNDzXBzf7+kA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009, Peter Zijlstra wrote:
> -#define PERF_COUNTER_IOC_ENABLE                _IO ('$', 0)
> -#define PERF_COUNTER_IOC_DISABLE       _IO ('$', 1)
> +#define PERF_COUNTER_IOC_ENABLE                _IOW('$', 0, u32)
> +#define PERF_COUNTER_IOC_DISABLE       _IOW('$', 1, u32)
>  #define PERF_COUNTER_IOC_REFRESH       _IOW('$', 2, u32)
> -#define PERF_COUNTER_IOC_RESET         _IO ('$', 3)
> +#define PERF_COUNTER_IOC_RESET         _IOW('$', 3, u32)

These ioctl definitions look malformed:
_IOW('$', 0, u32) means that the ioctl will read a u32 in user
space pointed to by (u32 __user *)arg, while what perf_ioctl
actually does is cast arg to a u32. Moreover, exported headers
should use __u32 instead of u32.

PERF_COUNTER_IOC_REFRESH apparently was broken already, this
patch also breaks the other definitions.

	Arnd <><
