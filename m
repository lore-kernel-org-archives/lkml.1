Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbYKECLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbYKECLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 21:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYKECLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 21:11:04 -0500
Received: from vs02.svr02.mucip.net ([83.170.6.69]:42658 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbYKECLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 21:11:01 -0500
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2008 21:11:01 EST
Date: Wed, 5 Nov 2008 03:03:40 +0100
From: Bernhard Schmidt <berni@birkenwald.de>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Long delays and keystrokes required - related to disk
	encryption?
Message-ID: <20081105020340.GA6399@schleppi.birkenwald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103073647.GB6313@corsac.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gmane.linux.kernel, Yves-Alexis Perez wrote:

> On Mon, Nov 03, 2008 at 08:23:27AM +0100, Yves-Alexis Perez wrote:
>> FTR, it seems fixed in 2.6.28-rc3 (I just git pull-ed the tree, so I
>> don't know which commit has fixed the problem)
>>
>> Could anyone (Frans?) confirm this?
>
> Hmhm ok, it's *not* fixed, it just appears a bit better, but it's
> still slow and hangs during boot process until I type some random
> keys.

I can confirm that (unfortunately).

Dell Latitude D630 amd64, Ubuntu Intrepid (8.10), unencrypted ext4 root
and encrypted (dm-crypt) ext4 /home.

After upgrading from the shipped 2.6.27 ubuntu kernel to 2.6.28-rc2 due
to totally buggy iwlagn (I had more crashes the last four weeks than
running devel kernels for years) I experienced exactly the same issue,
after entering the password into cryptsetup the machine did not continue
booting until I pressed a key. Any key, even holding down the ctrl-key
during bootup is fine. 2.6.28-rc3 shows the same behaviour.

However, I have a slight difference compared with Yves. I don't only
experience these hangs until all my filesystems are mounted, but during
the whole startup process at random stages. I usually have at least
three hangs during startup, with almost 100% certainity between entering
the keyphrase and getting the "Keyslot 0 unlocked" message from
dm-crypt, then at random daemons at startup and even on X startup
(before kdm shows the login screen). Pressing the Ctrl-key just once and
holding it during the whole bootup fixes it 100%.

Interestingly, since just my /home is on dm-crypt I tried to disable
that to ensure it is related to crypto and it seems to be. However, in
four bootups without crypt it showed the same symptoms, so it definitely
does happen without crypto as well, but by far not that frequent.

Regards,
Bernhard
