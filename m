Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZGNRvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZGNRvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZGNRvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:51:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbZGNRvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:51:37 -0400
Date: Tue, 14 Jul 2009 10:50:07 -0700
From: Greg KH <gregkh@suse.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
Message-ID: <20090714175007.GA9428@suse.de>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
 <20090709151803.GB24302@suse.de>
 <1247159613.4398.215.camel@localhost>
 <20090709175250.GB26378@suse.de>
 <1247167738.4398.229.camel@localhost>
 <20090709201257.GB27124@suse.de>
 <1247170786.4398.242.camel@localhost>
 <20090709204128.GA27638@suse.de>
 <1247589459.4398.372.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247589459.4398.372.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 12:37:39PM -0400, David P. Quigley wrote:
> So, I've been looking through the sysfs code and I can't find a
> reference to netlink in there. I am assuming that it is other parts of
> the kernel which make use of netlink which are calling the sysfs_*
> functions. Any suggestions for where to look on how this is being used
> and what the important users are?

The netlink messages are coming from the kobject uevent code, look in
lib/kobject_uevent.c for the code that creates and sends them out.  This
happens for every sysfs directory that is created that corresponds with
a kobject.

thanks,

greg k-h
