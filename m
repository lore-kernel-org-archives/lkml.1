Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYBEQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYBEQ7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYBEQ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:59:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44159 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYBEQ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:59:09 -0500
Date: Tue, 5 Feb 2008 08:58:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Hugh Dickins <hugh@veritas.com>, Jiri Kosina <jkosina@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205085841.51713a5d@laptopd505.fenrus.org>
In-Reply-To: <20080205154648.GA24331@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz>
	<Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
	<Pine.LNX.4.64.0802051243240.542@blonde.site>
	<20080205070001.7bc8058f@laptopd505.fenrus.org>
	<20080205154648.GA24331@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 16:46:48 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > > In my usual dither, I'm rather hoping Arjan will have a clear
> > > answer.
> > 
> > 
> > setarch works. If the apps come in source form they need fixing
> > anyway (since I'd not be surprised of current gcc reorders
> > variables), if not.. we only have 2 cases, the other case was the
> > build process of emacs (which got fixed 5 years ago).
> 
> uemacs ... broken with randomization
> colums, sss ... local programs, broken with randomization
> procinfo ... broken, randomization makes it die sooner.
> mikmod ... broken with randomization
> bsdsed ... broken with randomization
> ...
> Should I test few more?

ok throw that idea out of the window then

the combo of a config option + sysctl sounds the right way forward then ;(

Unless there's a way we can make sys_brk() detect this kind of behavior somehow...
we could track per process if brk(0) was called, and if not, do something fancy to work around stuff?



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
