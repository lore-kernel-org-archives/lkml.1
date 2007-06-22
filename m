Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbXFVHKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbXFVHKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbXFVHKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:10:35 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbXFVHKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:10:32 -0400
Message-ID: <467B7509.8010106@zytor.com>
Date: Fri, 22 Jun 2007 00:06:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com>	 <20070620210343.GQ21478@ftp.linux.org.uk>  <46799A31.10301@zytor.com>	 <1182442837.3342.13.camel@ram.us.ibm.com>  <467AB5EE.3030909@zytor.com> <1182494654.2812.22.camel@ram.us.ibm.com>
In-Reply-To: <1182494654.2812.22.camel@ram.us.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ram Pai wrote:
> 
> the second patch made a /proc/propagation interface which had almost the
> same fields, but also added fields to show the propagation type of the
> mount as well as pointers to its peers and master depending on the type
> of the mount. 
> 
> I think the consensus seems to have a new interface /proc/make-a-name
> which extends the interface provided by /proc/mounts but provides the
> propagation state of the mounts too as well as disambiguate bind mounts.
> Which makes sense.
> 

Why?  It seems a lot cleaner to have all the information in the same
place.  It is highly unfriendly to userspace to have to gather
information in a lot of places, plus it adds race conditions.

It would be another matter if the format that we have now couldn't be
extended, but we need those fields (well, except the two zeros, but who
cares) *anyway*, so we might as well stick to the existing file, and
reduce the total amount of code and clutter.

> 
> BTW: what is the need for overmounted flag?  Do you mean two vfsmounts
> mounted on the same dentry on the ***same vfsmount*** ?
> 

Maybe I'm not following the uses of your flags well enough to figure out
 if that information can already been deduced.

	-hpa
