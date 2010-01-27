Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556Ab0A0QtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0A0QtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400Ab0A0QtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:49:14 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:56790 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755373Ab0A0QtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:49:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jxlvH7S+oKH2Vs57hC+ZI07f5G44J2MISEugHWfIGOL0lTGZ3CjSComaBQkImGCHfx00MPCC9ENtAj6LQwD0ACBgwLyBO4958DXVjV71/ZY2j6bS3uxL5cPIm7n0lbZX;
Date: Wed, 27 Jan 2010 08:48:54 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: davidjon@xenontk.org
Cc: yakui.zhao@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fix For Korg Bug #14897 (GM45 Display Flicker)
Message-ID: <20100127084854.6da89284@jbarnes-piketon>
In-Reply-To: <4B60080E.2000508@xenontk.org>
References: <4B60080E.2000508@xenontk.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 15:01:58 +0530
David John <davidjon@xenontk.org> wrote:

> Hi Jesse, Yakui,
> 
> Sorry for the delay, but I was busy with other work last week. I got
> some time to look into this on Monday and the problem seems to be this:
> 
> With the external display connected on VGA, intel_update_watermarks
> calls update_wm a couple of times in sequence with the following params:
> 
> 1) planea_clock = 148500 planeb_clock = 0, sr_hdisplay=1920 (VGA)
> 2) planea_clock = 148500 planeb_clock = 72330, sr_hdisplay=1366 (LVDS)
> 
> In update_wm (in my case g4x_update_wm), for 1) sr_entries is calculated
> correctly and self refresh is enabled. For 2) sr_entries remains zero
> and the SR watermark is set as such. However, SR remains
> active. On mode switch to console, this causes a FIFO underrun and the
> display flicker.

Ugg that's not supposed to happen.  With both planes enabled
self-refresh shouldn't be active afaik.  I guess we'll actually have to
flip the bit and turn it off in that case.

> The solution that I see is to simply disable SR if more than one pipe is
> enabled. I've written a patch that does this. Also another point is that
> the G45 docs state that a particular sequence has to be followed if SR
> is to be used when only one pipe is active for Cantiga (Pg 30, G45 Vol
> 3). I didn't see any code doing this, but I did not see any untoward
> behaviour either, with only my patch applied.

Great, I'll look for it and ack it.

> I've updated the patch to fix i965 and i9xx as I assume the same problem
> will occur on those chipsets as well, but this has _not_been tested as I
> don't have the relevant platforms.

Yeah, it's probably the safe thing to do.

> 
> Patch follows this mail. Please let me know if any changes are required.
> 
> The VGA output powering-on on mode change mentioned in my bug report is
> a separate DRM bug for which I will send a patch later.

Thanks a lot.

-- 
Jesse Barnes, Intel Open Source Technology Center
