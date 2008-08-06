Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYHFDbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYHFDbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYHFDbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:31:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16283 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYHFDbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:31:22 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5354"; a="5180317"
Message-ID: <48991B07.3050500@qualcomm.com>
Date: Tue, 05 Aug 2008 20:31:19 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
In-Reply-To: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> I've a Dell R900 with 4 quad-core Xeon processors (total 16CPUs), but
> can only managed to boot up with CONFIG_NR_CPUS=8. Setting
> CONFIG_NR_CPUS=16 causes the kernel to hang while booting.

You could try booting CONFIG_NR_CPUS=16 with maxcpus=8 (kernel command line
option).

If it boots you can then try bringing the rest of the cpus online manually
	echo 1 > /sys/devices/system/cpu/cpu8/online
         ...
	echo 1 > /sys/devices/system/cpu/cpu15/online

Might get a better OOPS/BUG_ON/etc report.

Max
