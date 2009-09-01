Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZIAOeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZIAOeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZIAOeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:34:17 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:43817 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZIAOeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sk2D5ieoZElodVDdS21+8Fmr+zo+eN+nto6Zouczf88ZHdBJ8rt1pFwVhzMesws0Ou
         Tehvkd5uWSeMtah7RbHHJZylT6HIuCFMPJh6kwT7T8DVo6CeeVx3VE/+ihvSosBpjv0w
         4rVrEF854J4BT+0y74NGSm3dSYpfSjk0uJQ6A=
MIME-Version: 1.0
In-Reply-To: <e5d736f9-f805-41b4-83d3-2ef65bcb519a@d23g2000vbm.googlegroups.com>
References: <cWOyL-3Ys-15@gated-at.bofh.it> <e5d736f9-f805-41b4-83d3-2ef65bcb519a@d23g2000vbm.googlegroups.com>
From: Fernando Silveira <fsilveira@gmail.com>
Date: Tue, 1 Sep 2009 11:33:55 -0300
Message-ID: <6afc6d4a0909010733p3904f4fakcc170194a475da6a@mail.gmail.com>
Subject: Re: I/O and pdflush
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 18:57, Daniel J Blueman<daniel.blueman@gmail.com> wrote:
> On Jul 11, 6:30 pm, Fernando Silveira <fsilve...@gmail.com> wrote:
>> The problem is that after some time of data writing at 70MB/s, it
>> eventually falls down to about 25MB/s and does not get up again until
>> a loooong time has passed (from 1 to 30 minutes). This happens much
>> more often when "vm.dirty_*" settings are default (30 secs to expire,
>> 5 secs for writeback, 10% and 40% for background and normal ratio),
>> and when I set them to 1 second or even 0, the problem happens much
>> less often and the sticking period of 25MB/s is much lower.
> [snip]
>
> Generally, this sounds symptomatic of the (now well-documented)
> internal block management of the SSD delaying writes significantly
> over long use periods - the output from eg 'vmstat 3' will show all
> the time spent in I/O wait of course.
>
> In your case, the OCZ Core v2 SSD uses the famed JMicron JMF602 which
> chokes up with outstanding write requests, destroying latency and
> throughput with it. OCZ won't be releasing newer firmware for the Core
> v2, so one last-ditch option is to install the newer stock (non-OCZ
> validated, thus invalidating the warranty) JMicron firmware, which
> alleviates this somewhat. I've found this successful, though it's
> tricky to find!

Thanks, I'll keep that in mind. If no other safer solution else helps,
I'll update the JMicron.

> One other idea is to ensure the filesystem starts on an (at least)
> 128KB boundary, so as to submit complete erase blocks (usually 128KB).

I don't use any kind of filesystem, just plain sequential data dump. I
can change the block size for each write(2), but I'm already using a
huge one: 4MB. I tried lower and higher values before but it seems
that the 70~80MB/s rate is only reached with blocks of 1MB or bigger.

-- 
Fernando Silveira <fsilveira@gmail.com>
