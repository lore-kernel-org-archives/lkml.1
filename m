Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbZCOGuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbZCOGuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZCOGuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:50:44 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:65362 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbZCOGuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:50:44 -0400
From: Frans Pop <elendil@planet.nl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: DRM oops while starting second X.org session in chroot
Date: Sun, 15 Mar 2009 07:50:40 +0100
User-Agent: KMail/1.9.9
Cc: dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie
References: <200903141534.43443.elendil@planet.nl> <21d7e9970903141739td91f90sc7f8b2fd8ec06f49@mail.gmail.com>
In-Reply-To: <21d7e9970903141739td91f90sc7f8b2fd8ec06f49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903150750.41006.elendil@planet.nl>
X-OriginalArrivalTime: 15 Mar 2009 06:50:41.0438 (UTC) FILETIME=[5B400BE0:01C9A53A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009, Dave Airlie wrote:
> On Sun, Mar 15, 2009 at 12:34 AM, Frans Pop <elendil@planet.nl> wrote:
> > I had the oops below today after I tried to start a second X.org
> > session in a chroot using 'startx -- :1'. I think the problem here is
> > that the driver was loaded, but that the corresponding device did not
> > exist in /dev in the chroot (forgot to bind mount it). If that is the
> > cause, it would be nice if it was handled more gracefully than this
> > :-P
>
> Its a bug in userspace we can't do anything about at this point,
>
> The problem is we attach some information to the device inode and if
> you starting using an alternate inode it screws up, I think Thomas had
> suggested ways aruond this.
> We could probably make it a WARN_ON and fail DRI setup. 

Yes, that's what I'd expect. At least not allow it to hang the primairy X 
session. I understand that you cannot magically make DRI work in this 
situation.

Note that I did start X.Org successfully in the chroot a bit earlier when 
I did have /dev/ bind mounted to /<mychroot>/dev/.
