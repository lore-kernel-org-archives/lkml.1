Return-Path: <linux-kernel-owner+w=401wt.eu-S940186AbYCTAS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940186AbYCTAS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763718AbYCSXf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbYCSXfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:21 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080319124155.GN10722@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 19 Mar 2008 12:41:55 +0000)
Subject: Re: [patch 4/6] vfs: mountinfo show dominating group id
References: <20080313212641.989467982@szeredi.hu> <20080313212737.053993902@szeredi.hu> <20080319113704.GJ10722@ZenIV.linux.org.uk> <E1Jbx0r-00027l-0q@pomaz-ex.szeredi.hu> <E1JbxGg-0002Ec-SD@pomaz-ex.szeredi.hu> <20080319124155.GN10722@ZenIV.linux.org.uk>
Message-Id: <E1Jby0n-0002Tc-Gb@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 Mar 2008 14:07:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > So maybe some alternative, multi line format would be better?
> > > 
> > > MountID: 99
> > > ParentID: 88
> > > DevID: 0:34
> > > Type: foofs
> > > Source: /dev/foo
> > > Root: /
> > > MountPoint: /mnt/foo
> > > MountOpts: rw,noatime
> > > Opts: rw,errors=continue
> > > Propagation: shared:42
> > 
> > Which still doesn't fully solve the problem, since ->show_options()
> > can also spew newlines + MountID:.  Oh well.
> 
> a) ban newlines in ->show_options(); that's a requirement that is easy
> to formulate and understand, so it has a chance to survive the contact
> with reality.
> 
> b) the order is all wrong - *everything* that depends on fs type should
> be after fs type and everything else should be prior to it.  That way
> you don't need to know what the hell does this fs type spew in order to
> parse type-independent information.  In particular, "source" (BTW, why
> do you capitalize those?) certainly has no business being in front of
> fs type; as the matter of fact, I'm not at all sure that we _want_ it
> separated from the rest of type-dependent options.  The fact that mount(2)
> gets it in a separate argument is a historical accident...
> 
> c) since you are tagging the fields anyway, why do you need newlines?
> Moreover, you don't really need to tag everything - there's a well-defined
> beginning and optional fields between it and (type+rest) are the only
> things that needs to be tagged...  BTW, why bother with Propagation: part
> and gluing shared:... with slave:... into a single field?  Separate them
> with whitespace - you have recognizable prefixes right there.
> 

99 88 0:34 / /mnt/foo rw,noatime shared:42 slave:13 foofs /dev/foo,errors=continue

Something like that?  It assumes, that fs types never have ':' in
them, but that's acceptable.

Miklos
