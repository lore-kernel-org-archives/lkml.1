Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYHRUz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYHRUz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYHRUzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:55:14 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:49869 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbYHRUzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:55:12 -0400
Date: Mon, 18 Aug 2008 21:32:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rc2 when cross-building the kernel
Message-ID: <20080818193253.GA30856@uranus.ravnborg.org>
References: <48A63D98.3070900@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A63D98.3070900@lwfinger.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 09:38:16PM -0500, Larry Finger wrote:
> One of my i386 systems used just for testing can take up to 18 hours 
> to build a new kernel with about 200 modules. When performing a 
> bisection, this gets rather tedious. As a result, I moved the kernel 
> sources to an NFS volume, do the majority of the work as a cross-build 
> on my x86_64 computer, and only switch to the slow machine to install 
> the kernel and modules. Somewhere between 2.6.27-rc1 and -rc2, the 
> module installation broke because the build leaves 
> scripts/basic/fixdep as a 64-bit program that will not run on the 
> 32-bit system. Once I get to the i386 machine, I delete the two 
> programs from scripts/basic/, manually rebuild them with a 'make 
> scripts/basic/' and then do the final 'make modules_install install'.

Can you try do do a "make V=1 modules_install install" and post the
output up to and including the first call to fixdep.

Neither of these targets should use fixdep and I assume it is 
down in firmware/ but lets see.

Thanks,
	Sam
