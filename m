Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYHaQ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYHaQ4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYHaQ4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:56:40 -0400
Received: from 1wt.eu ([62.212.114.60]:3099 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbYHaQ4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:56:40 -0400
Date: Sun, 31 Aug 2008 18:55:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, mingo@elte.hu,
       torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch v2   0/5] Nano/Microsecond resolution for select() and poll()
Message-ID: <20080831165554.GG19337@1wt.eu>
References: <20080831092828.13ae0279@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080831092828.13ae0279@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Sun, Aug 31, 2008 at 09:28:28AM -0700, Arjan van de Ven wrote:
> One thing to note is that on my machine, the current select() implementation
> will return after 1997 microseconds when asked for 1999 microseconds; this
> can be seen in a zoom in of the graph above:
> http://www.tglx.de/~arjan/zoom.png
> E.g. select() is returning too early in current Linux kernels; and this is
> also fixed (by nature) by this patch series.

This is a good news. I've been bothered by this problem for a long time
and got used to add 99999 us to any delay fed to select() (that started
when HZ=100). I remember having noticed performance improvements in my
applications using this trick even on other systems, so I don't think
that Linux is the only one with this anomaly. I think it's simply caused
by the rounding methods which make it hard to compute an accurate deadline
when a value is converted before being added to jiffies.

I do not remember noticing this on epoll though. Maybe it's just because
I did not look close enough :-/

Cheers,
Willy

