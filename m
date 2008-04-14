Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYDNONp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYDNONp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYDNONi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:13:38 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:62672 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbYDNONh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:13:37 -0400
Message-ID: <48036649.6000409@freescale.com>
Date: Mon, 14 Apr 2008 09:12:25 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
References: <12053582234100-git-send-email-yorksun@freescale.com>	<12053582231281-git-send-email-yorksun@freescale.com>	<47D8572C.8090501@gmail.com>	<47FFDBFF.1030809@gmail.com> <20080411221817.0b1eb414.akpm@linux-foundation.org> <48035E93.6070300@freescale.com> <48035F98.1020404@gmail.com> <48036001.10905@freescale.com> <4803620C.6020905@gmail.com>
In-Reply-To: <4803620C.6020905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 04/14/2008 03:45 PM, Timur Tabi wrote:
>> Jiri Slaby wrote:
>>
>>> See
>>> http://lkml.org/lkml/2008/3/12/375
>> That email is dated 3/12 and those comments are about v1 of the patch.  The most
>> recent posted version is v5 and it addresses all these issues.  See
>> http://lkml.org/lkml/2008/4/1/346
> 
> Ok, how is the sleep-inside-spinlock in fsl_diu_open resolved? rh_alloc might 
> sleep if I still see correctly, do I?

Hmmm... I thought I had an answer to this question, but I checked the patch
again, and it looks like this particular issue hasn't been fixed.  rh_alloc can
still sleep.  I know we worked on fixing this bug, so I'm not sure why it's
still there.

However, we don't need to call rh_alloc().  The arch/powerpc code has been
updated to remove the need for us to a use an rheap.

Unfortunately, the author of the patch, York, is out this week, so I'll have to
take care of this.  It'd be easier to modify rh_alloc() so that it doesn't
sleep, so that's what I'm going to do.

-- 
Timur Tabi
Linux kernel developer at Freescale
