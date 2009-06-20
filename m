Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZFTGNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZFTGNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 02:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbZFTGNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 02:13:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:40366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZFTGNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 02:13:45 -0400
Message-ID: <4A3C7E10.2050806@suse.de>
Date: Sat, 20 Jun 2009 15:13:36 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, tiwai@suse.de,
       fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy 1.2 using CUSE
References: <48B6F711.1040604@kernel.org> <49E3F91E.4000801@suse.de> <E1Lwian-0004pq-8P@pomaz-ex.szeredi.hu> <49EFAF4D.2090509@suse.de>
In-Reply-To: <49EFAF4D.2090509@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mikos.

Tejun Heo wrote:
> Hello, Miklos.
> 
> Miklos Szeredi wrote:
>> Xmms with the OSS output plugin doesn't really work.  It plays like 10
>> times too fast and the output is not really recognizable.
> 
> Hmm...
> 
>> This is the debug output of osspd:
>>
>> osspd: OSS Proxy v1.2 (C) 2008-2009 by Tejun Heo <teheo@suse.de>
>> osspd: Creating dsp (14:3), adsp (14:12), mixer (14:0)
>> osspd DBG0: CREATE mixer(12799)
>> osspd DBG0: S[1/16744] CREATE slave=16745 /store/git/ossp/ossp-padsp
>> osspd DBG0: S[1/16744]   client=16744 cmd=7:8 notify=9:10
>> ossp-padsp[mszeredi:16745] DBG0: requested frag_size (4096) is smaller than mini
>> mum (4412)
>> ossp-padsp[mszeredi:16745] DBG0: CREATE PLAY s16le 2ch 44100Hz fsz=4412:25
>> ossp-padsp[mszeredi:16745] DBG0:   tlen=131072:743 max=139896:793 pre=8192:46
>> ossp-padsp[mszeredi:16745] DBG0:   u_sd=0 u_fsz=4096:23 u_maxf=32
>> osspd DBG0: S[1/16744] volume set=-1/-1:-1/-1 get=63/63:0/0
>> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
>> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
>> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
>> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
>> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun
>> ossp-padsp[mszeredi:16745] DBG0: PLAY stream underrun

Finally tried xmms.  It looks like a bug in pulseaudio.  pulseaudio is
throwing away data buffer after playing only fraction of it.
Interestingly, this can be avoided by having pavucontrol or other play
stream running.  Can you please verify that the problem goes away if
you have pavucontrol running?  There's also another problem with xmms.
The current version of ossp blocks mixer commands till the r/w
commands are complete and this makes xmms's UI stutter a bit.  I
modified osspd to lazy execute mixer commands while responding
immediately to the requester.  I'm testing it now and with pavucontrol
open, xmms works quite nicely.

Thanks.

-- 
tejun
