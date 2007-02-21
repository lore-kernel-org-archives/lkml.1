Return-Path: <linux-kernel-owner+w=401wt.eu-S1422723AbXBURbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422723AbXBURbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422724AbXBURbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:31:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:36066 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422723AbXBURbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:31:18 -0500
Date: Wed, 21 Feb 2007 09:29:49 -0800
From: Greg KH <greg@kroah.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: securityfs_create_dir strange comment
Message-ID: <20070221172949.GA16029@kroah.com>
References: <Pine.LNX.4.61.0702181642060.28890@yvahk01.tjqt.qr> <20070220211849.GA3416@vino.hallyn.com> <20070220222652.GB21696@kroah.com> <Pine.LNX.4.61.0702210042140.7132@yvahk01.tjqt.qr> <20070221040526.GA8207@kroah.com> <Pine.LNX.4.61.0702211805450.12039@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702211805450.12039@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 06:07:56PM +0100, Jan Engelhardt wrote:
> Hello Greg,
> 
> 
> On Feb 20 2007 20:05, Greg KH wrote:
> >
> >Try this instead:
> >	if (!de)
> >		return -ENOMEM;
> >	if ((IS_ERR(de)) && (PTR_ERR(de) != -ENODEV))
> >		return PTR_ERR(de);
> >	return 0;
> >
> >That should cover everything properly, right?
> 
> In case memory could not be allocated, why does not securityfs_*() return
> ERR_PTR(-ENOMEM) then? (I think, that's the quintessential question after
> all. And thanks for giving an example what to do in the ENODEV case.)

Actually, in reading the code (which might have helped in the first
place), we can never return NULL if securityfs is enabled.  So you can
just drop that first check entirely.

Which makes me wonder, it might be easier to just return NULL if
securityfs is not enabled in the kernel, as long as no one checks that
improperly...

Hope this helps,

greg k-h
