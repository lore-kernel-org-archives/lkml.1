Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbYCCAbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbYCCAbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYCCAa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:30:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41155 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbYCCAa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:30:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC] introduce pm_call() macro to get rid of most #ifdef CONFIG_PM
Date: Mon, 3 Mar 2008 01:29:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20080302234308.GA10116@zarina> <20080302160820.1930a770@laptopd505.fenrus.org>
In-Reply-To: <20080302160820.1930a770@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803030129.29087.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of March 2008, Arjan van de Ven wrote:
> On Mon, 3 Mar 2008 02:43:08 +0300
> Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> 
> > Currently drivers handle CONFIG_PM this way:
> > 
> > #ifdef CONFIG_PM
> > drv_suspend() {}
> > drv_resume() {}
> > #else
> > #define drv_suspend NULL
> > #define drv_resume NULL
> > #endif
> > 
> > struct driver drv = {
> > 	.suspend = drv_suspend,
> > 	.resume = drv_resume,
> > };
> > 
> > With this patch, the code above converts into:
> > 
> > drv_suspend() {}
> > drv_resume() {}
> > 
> > struct driver drv = {
> > 	.suspend = pm_call(drv_suspend),
> > 	.resume = pm_call(drv_resume),
> > };
> > 
> > GCC will optimize away suspend/resume calls if they're really
> > not used.
> > 
> 
> 
> to be honest, at this point I would think it's time to remove CONFIG_PM, or rather,
> just make it always be there and just get rid of the ifdefs. We're saving 2 words and a bit of code,
> but only a case that not even the embedded guys use. 

All of the drivers' ->suspend() and ->resume() callbacks currently depend on
CONFIG_PM, which they shouldn't.

Still, we're going to introduce new callbacks for suspend/hibernation and the
$subject change will probably get us in the way.  Also, it won't be necessary
afterwards.

Thanks,
Rafael
