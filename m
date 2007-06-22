Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbXFVH4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbXFVH4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXFVH4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:56:25 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56811 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbXFVH4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:56:23 -0400
Message-ID: <467B7F6F.4030007@zytor.com>
Date: Fri, 22 Jun 2007 00:51:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com>	 <20070620210343.GQ21478@ftp.linux.org.uk>  <46799A31.10301@zytor.com>	 <1182442837.3342.13.camel@ram.us.ibm.com>  <467AB5EE.3030909@zytor.com>	 <1182494654.2812.22.camel@ram.us.ibm.com>  <467B7509.8010106@zytor.com> <1182497690.2812.54.camel@ram.us.ibm.com>
In-Reply-To: <1182497690.2812.54.camel@ram.us.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ram Pai wrote:
> 
> Ok. so you think /proc/mounts can be extended easily without breaking
> any userspace commands?
> 
> well lets see..
> 1. to disambiguate bind mounts, we have to add a field that displays the
> 	 path to the mount's root dentry from the filesystem's root
> 	 dentry. Agree?
> 
> 2. For filesystems that do not have a backing store, it becomes hard
> 	to disambiguate bind mounts in (1). So we need to add a
> 	filesystem-id field.
> 
> 3. if we need to add the propagation status of the mount we need a
> 	 propagation flag added in the output.
> 
> 4. To be able to construct the propagation tree, we need a way to refer
> 	to the other mounts, since some mounts are peers and some other
> 	mounts are master. Which means we need a mount-id field.
> 	Agree?
> 
> If you agree to the above 4 new fields, it becomes challenging to
> extend /proc/mounts to incorporate these new fields without
> breaking any existing applications. 
> 

No, I don't think so.  I suspect, in fact, that as long as we add the
new fields to the right (obviously) we should be fine.  There aren't all
that many users of /proc/mounts, and even fewer that don't use the
library functions (getmntent et al.)

	-hpa
