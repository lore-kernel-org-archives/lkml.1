Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZK3STj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZK3STj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZK3STj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:19:39 -0500
Received: from [83.170.124.135] ([83.170.124.135]:57856 "EHLO
	pluto.daelnet.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZK3STi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:19:38 -0500
X-Greylist: delayed 2499 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 13:19:38 EST
Message-ID: <4B1402FC.80307@cybus.co.uk>
Date: Mon, 30 Nov 2009 17:38:04 +0000
From: Jonathan Miles <jon@cybus.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: OOM kernel behaviour
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm not on the list, so please cc me.

I'm trying to figure out why the OOM killer is being called on my
workstation even though the last time there was nearly 1.2GB of memory
used by the page cache, which IMHO could have been used instead. I
suffer from poor system performance due to it swapping (2GB RAM),
especially when returning after it being idle overnight, so I
experimented by switching off swap completely. Now it runs very quickly
except that an OOM state is reached unnecessarily.

With reference to the following description of kernel memory usage, is
there a way to tune the kernel such that it prefers to reclaim memory
from buffers/caches (e.g. page cache) rather than by swap or the OOM killer?

   http://linux-mm.org/Low_On_Memory

Above link says "the kernel starts to reclaim memory from the different
uses described above [buffers, cache]. The kernel can get memory back
from any of the these ... there are lots of pages of memory which are
user application data, but are rarely used. All of these are targets for
being swapped in favor of other uses for the RAM".

To stop it using swap, I guess /proc/sys/vm/swappiness is my friend, but
I took an even harder line by disabling swap completely. Why then is the
OOM killer being called?

I'm running kernel 2.6.31.

Regards,

Jon
