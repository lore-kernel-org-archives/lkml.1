Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZCYExv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZCYExv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZCYExm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:53:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:57492 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbZCYExl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:53:41 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
To: rusty@rustcorp.com.au
Subject: Strange code in include/linux/cpumask.h
Date: Wed, 25 Mar 2009 10:21:13 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: nikanth@gmail.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251021.13811.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty

I do not understand this code.

/**
 * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
 * @bitmap: the bitmap
 *
 * There are a few places where cpumask_var_t isn't appropriate and
 * static cpumasks must be used (eg. very early boot), yet we don't
 * expose the definition of 'struct cpumask'.
 *
 * This does the conversion, and can be used as a constant initializer.
 */
#define to_cpumask(bitmap)                                              \
        ((struct cpumask *)(1 ? (bitmap)                                \
                            : (void *)sizeof(__check_is_bitmap(bitmap))))

static inline int __check_is_bitmap(const unsigned long *bitmap)
{
        return 1;
}

The conditional operator would always evaluates to true and return bitmap. So 
all it seems to does is
#define to_cpumansk(bitmap) (struct cpumask *)(bitmap)

Even If it would return (void *)sizeof(__check_is_bitmap(bitmap)), wouldn't it 
be always
(struct cpumask *) (sizeof(1))!?

Is this some magic for type safety?

Thanks
Nikanth
