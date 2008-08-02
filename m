Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYHBPjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYHBPjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYHBPjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:39:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYHBPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:39:07 -0400
Message-ID: <48947E67.9060005@zytor.com>
Date: Sat, 02 Aug 2008 08:33:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, serue@us.ibm.com, matthltc@us.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>
Subject: Re: Per-instance devpts
References: <20080412172933.GA19295@us.ibm.com>	 <1208027215.28187.17.camel@x61.ebiederm.org>	 <48935205.3090807@zytor.com>	 <f73f7ab80808020004j15b0d0e5x5fa911242641b34d@mail.gmail.com> <f73f7ab80808020006i7f0ac456ve9b9f73568c11294@mail.gmail.com>
In-Reply-To: <f73f7ab80808020006i7f0ac456ve9b9f73568c11294@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> 
> Here's my suggestion:
> 
> By default, without any mount options, use the current "legacy"
> behavior.  The devpts filesystem would point to a "global" instance on
> the whole box, controlled by the traditional /dev/ptmx device node.
> There would *NOT* be a /dev/pts/ptmx node.
> 
> If the devpts filesystem is mounted with a special option ("permount"?
> "noglobal"?), then it will create a new devpts instance associated
> with the filesystem.  A devpts mounted that way *WILL* have a magic
> /dev/pts/ptmx node.
> 
> If the kernel is built with CONFIG_DEVPTS_FORCE_PERMOUNT then the
> traditional /dev/ptmx device node will be neutered (IE: always return
> -ENODEV) and the "permount" option will be forced for all devpts
> mounts.  This will also remove the static global devpts instance.
> 

Hm.  This might work if we can get the mount behaviour to work right. 
I'll think about it.  It definitely seems like a reasonable way to get 
from A to B.

	-hpa
