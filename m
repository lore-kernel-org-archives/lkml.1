Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZGNU0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZGNU0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 16:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbZGNU0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 16:26:45 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:62552 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbZGNU0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 16:26:45 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Greg KH <gregkh@suse.de>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <20090714175007.GA9428@suse.de>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <20090709151803.GB24302@suse.de> <1247159613.4398.215.camel@localhost>
	 <20090709175250.GB26378@suse.de> <1247167738.4398.229.camel@localhost>
	 <20090709201257.GB27124@suse.de> <1247170786.4398.242.camel@localhost>
	 <20090709204128.GA27638@suse.de> <1247589459.4398.372.camel@localhost>
	 <20090714175007.GA9428@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 14 Jul 2009 16:16:06 -0400
Message-Id: <1247602566.4398.376.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 10:50 -0700, Greg KH wrote:
> On Tue, Jul 14, 2009 at 12:37:39PM -0400, David P. Quigley wrote:
> > So, I've been looking through the sysfs code and I can't find a
> > reference to netlink in there. I am assuming that it is other parts of
> > the kernel which make use of netlink which are calling the sysfs_*
> > functions. Any suggestions for where to look on how this is being used
> > and what the important users are?
> 
> The netlink messages are coming from the kobject uevent code, look in
> lib/kobject_uevent.c for the code that creates and sends them out.  This
> happens for every sysfs directory that is created that corresponds with
> a kobject.
> 
> thanks,
> 
> greg k-h

It is unclear to me what if anything we need to do to the kobject_uevent
code for these changes. Do you have a particular use case in mind? Is
there some sort of notification that should be sent up to user space
when the label is changed on a file?

Dave

