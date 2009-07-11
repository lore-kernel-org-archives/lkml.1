Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZGKR1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZGKR1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 13:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZGKR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 13:27:47 -0400
Received: from mail-vw0-f199.google.com ([209.85.212.199]:62391 "EHLO
	mail-vw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZGKR1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 13:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=il56OcS7oEomyJlGq7P00iA+EMR6ST8USlgy1ClYCCLAALNYaInllxopbZodJ0az2V
         t1A1xWMfC2stLUoEV8iIe2oO22qy/YB3/0ij5VKhE0tZsA6dcd7orbGFWetiuCptPWAj
         upfuQofb8bsMvVcdNhY2vuFerp1pL1neLcaFo=
MIME-Version: 1.0
From: Fernando Silveira <fsilveira@gmail.com>
Date: Sat, 11 Jul 2009 14:27:25 -0300
Message-ID: <6afc6d4a0907111027w76234c8fv11ab77864515fdb0@mail.gmail.com>
Subject: I/O and pdflush
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm having a hard time with an application that writes sequentially
250GB of non-stop data directly to a solid state disk (OCZ SSD CORE
v2) device and I hope you can help me. The command "dd if=/dev/zero
of=/dev/sdc bs=4M" reproduces the same symptoms I'm having and writes
exactly as that application does.

The problem is that after some time of data writing at 70MB/s, it
eventually falls down to about 25MB/s and does not get up again until
a loooong time has passed (from 1 to 30 minutes). This happens much
more often when "vm.dirty_*" settings are default (30 secs to expire,
5 secs for writeback, 10% and 40% for background and normal ratio),
and when I set them to 1 second or even 0, the problem happens much
less often and the sticking period of 25MB/s is much lower.

In one of my experiences, I could see that writing some blocks of of
data (aprox. 48 blocks of 4MB each time) at a random position of the
"disk" increases the chances of decreasing the writing rate to 25MB/s.
You can see at this graph[1] that after the 7th random big write (at
66 GB) it falls down to 25MB/s. The writes happened at the following
positions (in GB): 10, 20, 30, 39, 48, 57, 66, 73, 80, 90, 100, 109,
118, 128, 137, 147, and 156 GB.

As I don't know much about kernel internals, IMHO it might be the SSD
might be "hiccuping" and some kind of kernel I/O scheduler or pdflush
decreases its rate to avoid write errors, I don't know.

Could somebody tell me how could I debug the kernel and any of its
modules to understand exactly why the writing is behaving this way?
Maybe I could do it just by logging write errors or something, I don't
know. Telling me which part I should start analyzing would be a huge
hint, seriously.

Thanks.

1. http://rootshell.be/~swrh/ssd-tests/ssd-no_dirty_buffer_with_random_192mb_writes.png

PS: This is used with two A/D converters which provide 25MB/s of data
each, leading my writing software to need at least 50MB/s of
sequential writing rate.

-- 
Fernando Silveira <fsilveira@gmail.com>
