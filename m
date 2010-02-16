Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab0BPRZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:25:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44385 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab0BPRZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:25:13 -0500
To: Octavian Purdila <opurdila@ixiacom.com>
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Amerigo Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v4 0/3] net: reserve ports for applications using fixed port
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 16 Feb 2010 09:25:04 -0800
In-Reply-To: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> (Octavian Purdila's message of "Tue\, 16 Feb 2010 00\:00\:38 +0200")
Message-ID: <m1sk916qkv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila <opurdila@ixiacom.com> writes:

> This iteration makes the bitmap dynamically allocated since it is
> quite big (8192 bytes) and adding that much in BSS may still,
> apparently, cause problems on some architectures.
>
>
> Octavian Purdila (3):
>   sysctl: refactor integer handling proc code
>   sysctl: add proc_dobitmap
>   net: reserve ports for applications using fixed port numbers
>

I don't like the /proc interface for this.  That is certainly not the
format I would choose for a bitmap.  The way you have described this
it looks like you are a set of different individual values instead of
one large value.  History says one value per file is the ideal in a
user space facing interface.  Intuitively I would not know how to
change your new proc interface after catting the file.  The classic
read the file tweak the value and write the new value back will not
work.


Also we already have a common function for dealing with bitmaps
in /proc.  bitmap_parse_user.  Used in /proc/irq/NNN/smp_affinity
among other places.

So can you please use bitmap_parse_user, or break this up into
64k individual files that we can set individually?

Eric
