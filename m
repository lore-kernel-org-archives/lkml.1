Return-Path: <linux-kernel-owner+w=401wt.eu-S933725AbXBZAoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725AbXBZAoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 19:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933733AbXBZAoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 19:44:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55919 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933725AbXBZAog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 19:44:36 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, john stultz <johnstul@us.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
	 <1172448057.3971.9.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 19:45:04 -0500
Message-Id: <1172450704.3971.30.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 16:24 -0800, Linus Torvalds wrote:
> Hmm. No, I don't think that should be a problem. free_initmem() only 
> happens at the very, after do_basic_setup() has been run, which includes 
> all the initcall stuff.

> However, it's an interesting observation. How sure are you that it's this 
> commit that triggers it. You say "This seems to be what's triggering ..", 
> I'm wondering how firm that is.. 

I found it with git-bisect. The Fedora kernel has been broken on this
particular 512MiB Mac Mini for a while, and now I've reverted the patch
it seems to be fine again. So I'm fairly sure. I'll be surer in a few
minutes once the full RPM build has finished with the patch reverted.

Of course, it could easily be an entirely separate bug which by some
bizarre coincidence is just triggered by this.

-- 
dwmw2

