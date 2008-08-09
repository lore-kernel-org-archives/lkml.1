Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbYHII61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbYHII61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 04:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYHII6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 04:58:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:8934 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYHII6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 04:58:17 -0400
Date: Sat, 9 Aug 2008 10:57:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 0/3] matroxfb fixes and improvements
Message-ID: <20080809105756.633b3658@hyperion.delvare>
In-Reply-To: <20080808140019.32d949f7.akpm@linux-foundation.org>
References: <20080808164937.141a95e0@hyperion.delvare>
 <20080808140019.32d949f7.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, 8 Aug 2008 14:00:19 -0700, Andrew Morton wrote:
> On Fri, 8 Aug 2008 16:49:37 +0200
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Not having heard of Petr in one month and a half, I am sending these 3
> > patches again. Patch 1/3 (matrox maven: Fix a broken error path) in
> > particular should be applied ASAP. Patch 2/3 (matroxfb: i2c structure
> > templates clean-up) would be good to have as well and I tested it.
> > Patch 3/3 (matrox maven: Convert to a new-style i2c driver) needs
> > testing before it can go upstream. I can't test it myself, but it has
> > been in linux-next for 6 weeks or so.
> 
> I'll put all three into 2.6.27.

Thank you.

> I suspect that #1 should be backported to 2.6.25.x and to 2.6.26.x but
> I am unsure about that due to its poor changelogging.
> 
> I _think_ that the machine will crash if the i2c_attach_client() or
> maven_init_client() calls fail.  But I don't know under what
> circumstances that can happen, nor whether the bug has been reported in
> the field, etc.

I found it while working on patch #3. I am not aware of it having been
reported in the field. The maven driver doesn't have that many users
(which is why I am struggling to get patch #3 tested.) And then the
errors in question are unlikely to happen. In fact, maven_init_client()
always returns 0, it simply cannot fail. So I'd say that the chances
that someone hits that bug are thin.

That would mean that we don't really need to backport the fix. But OTOH
it's a regression and the fix is pretty easy and not intrusive. So, I
think I would still backport it.

> And the -stable people also will be interested in such information when
> making their decisions.

I think I will let them decide.

-- 
Jean Delvare
