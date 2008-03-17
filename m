Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYCQTI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYCQTI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYCQTIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:08:49 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:45504 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYCQTIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:08:48 -0400
X-Greylist: delayed 1730 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2008 15:08:48 EDT
Date: Mon, 17 Mar 2008 19:39:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.25-rc6
Message-ID: <20080317193941.6f247ea1@hyperion.delvare>
In-Reply-To: <47DE815C.4060906@googlemail.com>
References: <alpine.LFD.1.00.0803161651350.3020@woody.linux-foundation.org>
	<47DE815C.4060906@googlemail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabriel,

On Mon, 17 Mar 2008 15:34:04 +0100, Gabriel C wrote:
> Linus Torvalds wrote:
> 
> > Zhang, Rui (2):
> >       thermal: fix generic thermal I/F for hwmon
> 
> That commit broke lmsensros here ( found by bisect ). 
> ...
> 
> Can't access procfs/sysfs file
> Kernel interface access error
> For 2.6 kernels, make sure you have mounted sysfs and libsensors
> was compiled with sysfs support!
> 
> ...
> 
> Of course proc and sysfs is mounted and the lib has that support :)

This has been reported as:
http://bugzilla.kernel.org/show_bug.cgi?id=10259
https://bugzilla.redhat.com/show_bug.cgi?id=437637

The generic thermal zone device does something which is not
fundamentally incorrect but that libsensors doesn't expect, and
unfortunately libsensors was not made robust enough and dies instead of
just ignoring the new unexpected device. libsensors 2.10.x is already
fixed in lm-sensors' SVN [1] and a tentative patch is available for
libsensors 3.0.x [2], however I am worried that kernel 2.6.25 will be
released before any new version of lm-sensors so pretty much every user
of lm-sensors will hit the problem if they upgrade to the new kernel.
For this reason, I think we really should let the new generic thermal
zone driver build as a module, and make it's hwmon support optional and
disabled by default for 2.6.25 [3]. This will help mitigate the risk of
massive breakage and complaints.

[1] http://www.lm-sensors.org/changeset/5147
[2] https://bugzilla.redhat.com/attachment.cgi?id=298270
[3] http://lists.lm-sensors.org/pipermail/lm-sensors/2008-March/022724.html

-- 
Jean Delvare
