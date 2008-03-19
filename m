Return-Path: <linux-kernel-owner+w=401wt.eu-S1161998AbYCTAV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161998AbYCTAV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936149AbYCSXfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366AbYCSXfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:34 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080319113704.GJ10722@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 19 Mar 2008 11:37:04 +0000)
Subject: Re: [patch 4/6] vfs: mountinfo show dominating group id
References: <20080313212641.989467982@szeredi.hu> <20080313212737.053993902@szeredi.hu> <20080319113704.GJ10722@ZenIV.linux.org.uk>
Message-Id: <E1Jbx0r-00027l-0q@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 Mar 2008 13:03:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Show peer group ID of nearest dominating group that has intersection
> > with the mount's namespace.
> 
> There's an obvious problem here: ->show_options() can spew _anything_,
> including a string that ends on " shared:42".

Yeah, even though I'd call that very broken, I wouldn't like to go
auditing filesystems for such breakage.

>  Makes reliable parsing of
> the damn thing in userland impossible.  IOW, fs options should go _last_
> and they should follow an unconditionally present field.

But then we lose the ability to later extend the format by adding
fields at the end.  Which is one of the things that would be nice to
have, in contrast to /proc/mounts, which we are so afraid to touch now.

So maybe some alternative, multi line format would be better?

MountID: 99
ParentID: 88
DevID: 0:34
Type: foofs
Source: /dev/foo
Root: /
MountPoint: /mnt/foo
MountOpts: rw,noatime
Opts: rw,errors=continue
Propagation: shared:42

Miklos
