Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZFBChY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZFBChY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 22:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbZFBChN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 22:37:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42073 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbZFBChM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 22:37:12 -0400
Date: Mon, 1 Jun 2009 21:43:06 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: lizf@cn.fujitsu.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] TOMOYO: Clarify lock protected section.
Message-ID: <20090602024306.GB21564@hallyn.com>
References: <200906020143.n521hGGP003698@www262.sakura.ne.jp> <4A248C90.9010904@cn.fujitsu.com> <200906020230.n522UjfJ013581@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906020230.n522UjfJ013581@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> Li Zefan wrote:
> > Tetsuo Handa wrote:
> > > Enclose reader section in
> > > 	/***** READER SECTION START *****/
> > > and
> > > 	/***** READER SECTION END *****/
> > > and writer section in
> > > 	/***** WRITER SECTION START *****/
> > > and
> > > 	/***** WRITER SECTION END *****/
> > > in order to avoid oversighting lock protected section.
> > > 
> > 
> > This makes me a bit uncomfortable..
> > 
> > IMHO this seems ugly, useless, and even harmful. If it's helpful,
> > we'd be doing this for the whole kernel tree, which is crazy..
> > 
> > Or does tomoyo do this for it's special reason?
> 
> I intended to help reviewers to visualize the range of protected section
> at a glance. But if reviewers feel noisy, I can remove these markers.

No, the real problem is that you have "protected sections" at all.

You should be locking data, not code.  (Apparently a quote to be attributed
to Alan Cox - huh)

See the bottom of:
http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/x376.html

-serge
