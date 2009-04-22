Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZDVT7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZDVT7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZDVT66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:58:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39998 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbZDVT65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:58:57 -0400
To: teheo@suse.de
CC: linux-kernel@vger.kernel.org, greg@kroah.com, miklos@szeredi.hu,
       tiwai@suse.de, fuse-devel@lists.sourceforge.net
In-reply-to: <49E3F91E.4000801@suse.de> (message from Tejun Heo on Tue, 14 Apr
	2009 11:46:54 +0900)
Subject: Re: [ANNOUNCE] OSS Proxy 1.2 using CUSE
References: <48B6F711.1040604@kernel.org> <49E3F91E.4000801@suse.de>
Message-Id: <E1Lwian-0004pq-8P@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Apr 2009 21:58:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009, Tejun Heo wrote:
> OSSP 1.2 available.  It now can do mmap for both playback and
> recording.  All my quakes and dooms run and sound fine.  :-)
> 
>   http://userweb.kernel.org/~tj/ossp/

Xmms with the OSS output plugin doesn't really work.  It plays like 10
times too fast and the output is not really recognizable.

This is the debug output of osspd:

osspd: OSS Proxy v1.2 (C) 2008-2009 by Tejun Heo <teheo@suse.de>
osspd: Creating dsp (14:3), adsp (14:12), mixer (14:0)
osspd DBG0: CREATE mixer(12799)
osspd DBG0: S[1/16744] CREATE slave=16745 /store/git/ossp/ossp-padsp
osspd DBG0: S[1/16744]   client=16744 cmd=7:8 notify=9:10
ossp-padsp[mszeredi:16745] DBG0: requested frag_size (4096) is smaller than mini
mum (4412)
ossp-padsp[mszeredi:16745] DBG0: CREATE PLAY s16le 2ch 44100Hz fsz=4412:25
ossp-padsp[mszeredi:16745] DBG0:   tlen=131072:743 max=139896:793 pre=8192:46
ossp-padsp[mszeredi:16745] DBG0:   u_sd=0 u_fsz=4096:23 u_maxf=32
osspd DBG0: S[1/16744] volume set=-1/-1:-1/-1 get=63/63:0/0
ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
[...message repeated zillion times]

I guess this has something to do with the too small frag size, but
couldn't figure out how all this works in prepare_streams() and
padsp_write().

Thanks,
Miklos
