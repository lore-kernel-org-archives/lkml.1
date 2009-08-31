Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZHaWri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZHaWri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 18:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZHaWri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 18:47:38 -0400
Received: from mail-yw0-f143.google.com ([209.85.211.143]:59613 "EHLO
	mail-yw0-f143.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZHaWrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 18:47:37 -0400
X-Greylist: delayed 3037 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Aug 2009 18:47:37 EDT
MIME-Version: 1.0
Date: Mon, 31 Aug 2009 14:57:02 -0700 (PDT)
In-Reply-To: <cWOyL-3Ys-15@gated-at.bofh.it>
X-IP: 86.25.246.118
References: <cWOyL-3Ys-15@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.2) 
	Gecko/20090810 Ubuntu/9.10 (karmic) Firefox/3.5.2,gzip(gfe),gzip(gfe)
Message-ID: <e5d736f9-f805-41b4-83d3-2ef65bcb519a@d23g2000vbm.googlegroups.com>
Subject: Re: I/O and pdflush
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Fernando Silveira <fsilveira@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 11, 6:30 pm, Fernando Silveira <fsilve...@gmail.com> wrote:
> The problem is that after some time of data writing at 70MB/s, it
> eventually falls down to about 25MB/s and does not get up again until
> a loooong time has passed (from 1 to 30 minutes). This happens much
> more often when "vm.dirty_*" settings are default (30 secs to expire,
> 5 secs for writeback, 10% and 40% for background and normal ratio),
> and when I set them to 1 second or even 0, the problem happens much
> less often and the sticking period of 25MB/s is much lower.
[snip]

Generally, this sounds symptomatic of the (now well-documented)
internal block management of the SSD delaying writes significantly
over long use periods - the output from eg 'vmstat 3' will show all
the time spent in I/O wait of course.

In your case, the OCZ Core v2 SSD uses the famed JMicron JMF602 which
chokes up with outstanding write requests, destroying latency and
throughput with it. OCZ won't be releasing newer firmware for the Core
v2, so one last-ditch option is to install the newer stock (non-OCZ
validated, thus invalidating the warranty) JMicron firmware, which
alleviates this somewhat. I've found this successful, though it's
tricky to find!

One other idea is to ensure the filesystem starts on an (at least)
128KB boundary, so as to submit complete erase blocks (usually 128KB).

Thanks,
  Daniel
--
Daniel J Blueman
