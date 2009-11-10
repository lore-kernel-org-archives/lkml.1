Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbZKJX0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbZKJX0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbZKJX0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:26:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758535AbZKJX0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:26:45 -0500
Date: Tue, 10 Nov 2009 15:26:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Mack <daniel@caiaq.de>, David Newall <davidn@davidnewall.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Clemens Ladisch <clemens@ladisch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
Message-Id: <20091110152605.fc8e760e.akpm@linux-foundation.org>
In-Reply-To: <20091110210940.GA1590@ucw.cz>
References: <4AF7D439.4030305@ladisch.de>
	<20091109091044.GX29442@buzzloop.caiaq.de>
	<4AF7DDC1.4090006@ladisch.de>
	<20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
	<4AF7FC64.6030904@ladisch.de>
	<20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
	<20091109145056.GB14091@buzzloop.caiaq.de>
	<4AF8582B.2000403@davidnewall.com>
	<20091109220944.GH14091@buzzloop.caiaq.de>
	<20091110210940.GA1590@ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 22:09:41 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> On Mon 2009-11-09 23:09:44, Daniel Mack wrote:
> > On Tue, Nov 10, 2009 at 04:28:03AM +1030, David Newall wrote:
> > > Daniel Mack wrote:
> > > > And even if the cursor behaviour is changable at runtime, I don't see
> > > > why it shouldn't have a selectable compile time default. Which is what
> > > > the patch adds.
> > > 
> > > 
> > > It seems like adding cruft to the kernel that is just as effectively
> > > available at run-time. Where does it end? Do we eventually add bash to
> > > the kernel?
> > 
> > One more thing:
> > 
> > Clemens' last patch didn't add anything to the kernel's binary size.
> > It didn't slow down anything either, as there is no run-time condition
> > evaluation. It just makes something configurable which was hard
> > coded before. So where's the cruft?
> 
> The number of configs to test just got bigger. 100% bigger in
> fact. Every single developer will have to answer 'do you want blinking
> cursor?' when your patch is merged.
> 
> config options _are_ expensive.
> 

Plus it's nice not to have to rebuild and reinstall the kernel to flip
a single bit...

The module_param() approach seems OK to me.


The initial patch was busted, IMO:

> @@ -1288,7 +1296,8 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
> 	int y;
>  	int c = scr_readw((u16 *) vc->vc_pos);
> 
> -	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
> +	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1 ||
> +	    fbcon_disable_cursor)
> 		return;

this will disable the cursor forever, afacit.  So if you boot with the
fbcon_disable_cursor option, you cannot later enable the cursor.

