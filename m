Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYDJOOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYDJOOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYDJOOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:14:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:51800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbYDJOOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:14:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: joern@logfs.org
Subject: Re: [patch 4/15] fs/logfs/compr.c
Date: Thu, 10 Apr 2008 16:13:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
References: <20080401181308.512473173@logfs.org> <20080401181332.853833004@logfs.org>
In-Reply-To: <20080401181332.853833004@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804101613.48465.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18eNtwzDeZ4uGIxijQFxyf4fMAqE9gvjVEjUxJ
 8RYvANVqBidx8z9Og0TBS3Q3zEhMA0Zioa0IZBKeiV2wwFjIof
 sLQMUHksJQmiOP1y3OBzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008, joern@logfs.org wrote:
> +
> +static DEFINE_MUTEX(compr_mutex);
> +static struct z_stream_s stream;
> +

How much time is spent in the compression code? Would it be helpful
to have a percpu stream and do preempt_disable around it instead
of the mutex?

That would improve parallelism and cache-locality of the compression,
at the cost of adding a source of latency to preemptible kernels.

	Arnd <><
