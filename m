Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbXJHMec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbXJHMec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbXJHMdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:33:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbXJHMdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:33:41 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [5/6] scheduler: Protect important kernel threads against normalize_rt
Date: Mon, 8 Oct 2007 14:33:34 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200710071059.126674000@suse.de> <20071007205958.7D8C41474B@wotan.suse.de> <20071008115142.GE22199@elte.hu>
In-Reply-To: <20071008115142.GE22199@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710081433.34845.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2007 13:51:42 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > Not only the migration thread, but also softlockup and stop machine 
> > need to be protected against normalize_rt(). Instead of checking for 
> > them all I added a new process flag for this.
> 
> hm, i dont really like this. The migration thread is an absolute 
> exception because it's needed for a correct scheduler. SysRq-N is like 
> SysRq-U or SysRq-B - last-minute resort in case something Goes Foul. 
> Results are not guaranteed.

softlockup is the same. Just think about it.

If you ever renormalize it and then run a fifo thread it will
starve and then eventually kill the box.

And starving CPU unplug is also equally bad.

-Andi
