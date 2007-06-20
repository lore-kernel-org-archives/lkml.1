Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbXFTWoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbXFTWoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXFTWoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:44:01 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbXFTWn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:43:59 -0400
Message-ID: <4679ACBD.4090200@zytor.com>
Date: Wed, 20 Jun 2007 15:39:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk> <20070620222437.GY7226@petra.dvoda.cz>
In-Reply-To: <20070620222437.GY7226@petra.dvoda.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak wrote:
> 
>  Yeah. How about include propagation trees to this file?
> 
>  mountpoint + ID + relative path + type + options + propagation-flag +
>  {peer,master}-mount-id
> 
>  / 0xa917800 / ext3 rw PRIVATE
>  /mnt 0xa917100 / ext3 rw SHARED peer:0xa917100
>  /tmp 0xa917f00 /1 ext3 rw SLAVE master:0xa917100
> 

I think we're talking about a different meaning of "id" here... you seem
to be talking about the vfsmount pointer, whereas it was originally
proposed as mnt_sb->sb_dev.  Both are useful, for different reasons of
course.

We should include mnt_devname as well.

People are a bit nervous about exposing kernel pointers in userspace, I
have noticed; would it be better to add a "mnt_id" field to struct
vfsmount; this can simply be a counter assigned when the structure is
assigned and then never changed (it might have to be a 64-bit counter,
but I don't think that adding 8 bytes to struct vfsmount should be a
huge deal.)

Does that service everyone's needs?

	-hpa
