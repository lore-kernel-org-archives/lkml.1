Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbZE3Dun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbZE3Dun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 23:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZE3Duf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 23:50:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755816AbZE3Due (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 23:50:34 -0400
Date: Fri, 29 May 2009 20:50:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Fredrik Arnerup" <fredrik.arnerup@edgeware.tv>
Cc: <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: IFF_LOWER_UP does not fit in ifr_flags
Message-Id: <20090529205028.3e01786b.akpm@linux-foundation.org>
In-Reply-To: <89A39FC0957640879F8975880836CF91@edgeware.tv>
References: <89A39FC0957640879F8975880836CF91@edgeware.tv>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 14:59:05 +0200 "Fredrik Arnerup" <fredrik.arnerup@edgeware.tv> wrote:

> Documentation/networking/operstates.txt (and netdevice(7)) claims that
> the flags IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO can be read from user space
> using ioctl() with SIOCGIFFLAGS. Looking in include/linux/if.h however,
> the flags are returned in a struct ifreq in the field ifr_flags which
> is declared as a short, while the flags are defined as:
> 
> #define IFF_LOWER_UP    0x10000         /* driver signals L1 up         */
> #define IFF_DORMANT     0x20000         /* driver signals dormant       */
> #define IFF_ECHO        0x40000         /* echo sent packets            */
> 
> Those aren't shorts, are they? In net/core/dev.c dev_get_flags() returns
> an unsigned which is assigned to ifr_flags directly.
> 
> Looked at linux/kernel/git/stable/linux-2.6.29.y.git.
> CC me please.
> 

(cc netdev)
