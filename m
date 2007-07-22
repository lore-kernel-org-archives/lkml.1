Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbXGVF1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbXGVF1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbXGVF1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:27:23 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:55734 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbXGVF1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:27:21 -0400
X-Greylist: delayed 1364 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jul 2007 01:27:21 EDT
To: adobriyan@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parse_table() earlier check.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200707200337.l6K3bjDr053658@www262.sakura.ne.jp>
	<20070721192946.GA5772@martell.zuzino.mipt.ru>
In-Reply-To: <20070721192946.GA5772@martell.zuzino.mipt.ru>
Message-Id: <200707221404.DDF46970.OSFJMFQVFtOOHL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sun, 22 Jul 2007 14:04:36 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alexey Dobriyan wrote:
> On Fri, Jul 20, 2007 at 12:37:45PM +0900, Tetsuo Handa wrote:
> > --- linux-2.6.22-orig/kernel/sysctl.c
> > +++ linux-2.6.22/kernel/sysctl.c
> > @@ -1190,9 +1190,9 @@
> >  		return -ENOTDIR;
> >  	if (get_user(n, name))
> >  		return -EFAULT;
> > +	if (!n)
> > +		return -ENOTDIR;
> >  	for ( ; table->ctl_name || table->procname; table++) {
> > -		if (!table->ctl_name)
> > -			continue;
> >  		if (n == table->ctl_name) {
> >  			int error;
> >  			if (table->child) {
> 
> I don't like this. For one, it destroy some symmetry in sysctl table
> walking code, where sysctl(2) code checks for valid ->ctl_name, and proc
> code checks for valid ->procname and both have same for loop. For two,
> nobody uses sysctl(2), sysctl aren't big, so this optimization is
> unneeded.

Excuse me, but I didn't understand what you are worrying.
I'm saying that:
  If n == 0, the condition "if (n == table->ctl_name)" is always false
  because of previous "if (!table->ctl_name) continue;" statement
  regardless of the result whether ->ctl_name and/or ->procname are valid or not.
  Thus, they always return -ENOTDIR if n == 0.
Why this optimization destroys something?
Should "if (!table->ctl_name)" be
 	for ( ; table->ctl_name || table->procname; table++) {
-		if (!table->ctl_name)
+		if (!table->procname)
 			continue;
 		if (n == table->ctl_name) {
 			int error;
 			if (table->child) {
or something?

Regards.
