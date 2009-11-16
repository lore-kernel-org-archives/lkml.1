Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZKPTxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZKPTxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZKPTxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:53:36 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64935 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZKPTxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:53:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EoA87eHvdAAXbOiaK/pr6bRAJ26xku45Ka+Vxq56BBGKi3cHgf5uuso6SrpNOIG5ui
         DD2HRWqggDTKg2LrkssSUK3VW5BCGDnrmMRubPDZ5Fu5augIXyIdflORZB+vyIsTxfV9
         vk6xVipyDyctBYIWiz3cF7uJxX7lKNRvnbHDI=
Date: Mon, 16 Nov 2009 11:53:32 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: fix wrong synaptics detection in
	psmouse_extensions()
Message-ID: <20091116195332.GD24026@core.coreip.homeip.net>
References: <alpine.LSU.2.00.0911161245570.15039@wotan.suse.de> <20091116170151.GA24026@core.coreip.homeip.net> <alpine.LSU.2.00.0911161806580.15039@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911161806580.15039@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 06:12:39PM +0100, Jiri Kosina wrote:
> 
> [ fixed linux-input CC which I have typoed previously ]
> 
> On Mon, 16 Nov 2009, Dmitry Torokhov wrote:
> 
> > On Mon, Nov 16, 2009 at 12:51:30PM +0100, Jiri Kosina wrote:
> > > Commit b7802c5c1ea ("Input: psmouse - use boolean type") caused the 
> > > synaptics_hardware variable to be completely useless, as it is constantly 
> > > set to 'true' throughout the whole psmouse_extensions(). This was caused 
> > > by the following hunk in the commit in question
> > > 
> > > 	-       int synaptics_hardware = 0;
> > > 	+       bool synaptics_hardware = true;
> > > 
> > > which is wrong. Fix that up.
> > 
> > Hmm, not sure what I was thinnking at that time but it is obviously I
> > should have stayed away form tehe keyboard...
> > 
> > Applied, thank you Jiri.
> 
> I guess you will be pushing that one to .32 still, right? 

Yes, I will try to get it in .32

> I think it's 
> quite crucial fix, so if it doesn't make it in time for .32 (I am not sure 
> whether Linus will be doing next -rc or not), it should go to -stable for 
> .32 right away.

Actually it is not that critical, it will only cause us to do an
unnecessary full reset when every protocol detection failed and we
resort to the bare PS/2 protocol. Still  the fix is tiny so might as
well do stable if it misses release.

-- 
Dmitry
