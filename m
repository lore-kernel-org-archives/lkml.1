Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0BHXlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:41:01 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:43384 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752445Ab0BHXk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:40:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=EFwz+I1FCqfK3RK8msOnUFXjZ2ZWXY7Svp1gh+kJZ9QVzbTFpOZu278HGN4i9K5DMs0lY3lY0huFeSLPADVXlinGRmeEhbPPJQw2zFAF775rEAjUXXQyKKCEZS7Z41xF;
Date: Mon, 8 Feb 2010 15:39:50 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Wilson <chris@chris-wilson.co.uk>, tomas m <tmezzadra@gmail.com>
Subject: Re: [Bug #15004] i915: *ERROR* Execbuf while wedged
Message-ID: <20100208153950.73f4e9a5@jbarnes-piketon>
In-Reply-To: <20100208200044.GA2677@think>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	<de962C6zBxL.A.bvE.cFiZLB@chimera>
	<20100205110100.57852c31@jbarnes-piketon>
	<20100205190916.GD2858@think>
	<20100205111747.6619b09b@jbarnes-piketon>
	<20100208172410.GA11311@think>
	<20100208093551.58a10643@jbarnes-piketon>
	<20100208200044.GA2677@think>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010 15:00:44 -0500
Chris Mason <chris.mason@oracle.com> wrote:

> On Mon, Feb 08, 2010 at 09:35:51AM -0800, Jesse Barnes wrote:
> > > 
> > > Ok, updating to rc7 and updating my xf86 driver to 2.10 seems to
> > > have fixed up my suspend/resume problems.  So, I should be able
> > > to trigger the execbuf problem again.
> > 
> > I've heard some reports that the 2D driver introduces and fixes
> > hangs, so it's possible 2.10 will fix both issues for you.
> > 
> > > Well, the rebooting isn't a huge deal, but if there's something I
> > > can track/kick or force to core dump, would it help?
> > 
> > We do have a test in intel-gpu-tools that will instigate a hang,
> > but it would be best to figure out what's causing it in your
> > environment.
> > 
> 
> [63516.632060] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
> elapsed... GPU hung [63516.632069] render error detected, EIR:
> 0x00000000 [63516.632092] [drm:i915_do_wait_request] *ERROR*
> i915_do_wait_request returns -5 (awaiting 2590581 at 2590579)
> 
> So, this popped up while surfing in firefox, which is usually where I
> hit the execbuf errors.  X was totally stuck afterwards, but I could
> switch to a vc and get the dmesg.
> 
> If there are specific procs that I can try to get traces of, just let
> me know for next time.

Hm, EIR is clear so this may be a failure of our hangcheck timer.

Chris Wilson saw these recently too; hoping he has ideas.

-- 
Jesse Barnes, Intel Open Source Technology Center
