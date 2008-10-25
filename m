Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYJYTMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYJYTMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 15:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYJYTMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 15:12:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:36275 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYJYTMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 15:12:35 -0400
Date: Sat, 25 Oct 2008 12:12:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc1 regression] wmifinfo dockapp takes 100% of cpu
 (bisected)
Message-ID: <20081025121244.07cdd6d7@infradead.org>
In-Reply-To: <20081025180322.GA10932@joi>
References: <20081025094043.GA4438@localhost.aei.mpg.de>
	<490327B6.2090903@linux.intel.com>
	<20081025071348.63c426d9@infradead.org>
	<20081025162503.GA4001@localhost.aei.mpg.de>
	<20081025180322.GA10932@joi>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008 20:03:27 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > >  		if (copy_from_user(&tv, tvp, sizeof(tv)))
> > >  			return -EFAULT;
> > >  
> > > +		while (tv.tv_usec > USEC_PER_SEC && i < 1000) {
>                                   ^ 
> should be >=

yeah thanks for catching that. Note to self: don't code before coffee

I'm not very happy with a while loop; but at least it solves the problem

I'll try to make it nicer than this ...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
