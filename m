Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZDNHxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZDNHxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZDNHxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:53:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:51943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZDNHxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:53:05 -0400
Message-ID: <49E440D9.4020803@kernel.org>
Date: Tue, 14 Apr 2009 16:52:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 /proc/diskstats
References: <49E13D18.2090805@solemnwarning.net>
In-Reply-To: <49E13D18.2090805@solemnwarning.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 07:53:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Collins wrote:
> Hi
> 
> Since 2.6.28, fd0 isn't visible in /proc/diskstats from boot, only after
> access/mount. It is visible in /sys/block/ from boot, so there are no
> issues detecting it. This may also affect other devices such as hda but
> I haven't tested this yet, my test system and QEMU both only have
> ram0-ram15 from boot. I have tested 2.6.30-rc1 and found the same
> behavior. Is this a bug or a deliberate change?

Hmm... the reason why fd device is skipped before the first open is
because diskstats_show() skips zero sized devices and open is when the
floppy driver sets the capacity.  I think the original code also
skipped zero sized device.  It could be that the original code
triggered revalidation while the current one doesn't.  I'll dig
deeper.

Thanks.

-- 
tejun
