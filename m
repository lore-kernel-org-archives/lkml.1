Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYKUUm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYKUUm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYKUUmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:42:19 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:31280 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbYKUUmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:42:19 -0500
Message-ID: <49271D1A.8040509@oracle.com>
Date: Fri, 21 Nov 2008 12:42:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <wfg@linux.intel.com>
Subject: Re: [PATCH linux-next] snd-hda: fix build errors
References: <20081121181948.ee771502.sfr@canb.auug.org.au>	<492713E8.9080103@oracle.com> <s5hy6zc7rjr.wl%tiwai@suse.de>
In-Reply-To: <s5hy6zc7rjr.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.49271D1E.0006:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Fri, 21 Nov 2008 12:02:48 -0800,
> Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> First error comes from snd_hda_eld_proc_new() not being static
>> when CONFIG_PROC_FS=n.  After that is fixed, the next problem is:
>> ERROR: "snd_print_pcm_rates" [sound/pci/hda/snd-hda-intel.ko] undefined!
>>
>> so I made a static inline version of that one too, for CONFIG_PROC_FS=n.
>> Please build/test more config variations.
>>
>>   LD [M]  sound/pci/hda/snd-hda-intel.o
>> sound/pci/hda/hda_eld.o: In function `snd_hda_eld_proc_new':
>> (.text+0x0): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> sound/pci/hda/hda_hwdep.o: In function `snd_hda_eld_proc_new':
>> (.text+0x0): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> sound/pci/hda/hda_generic.o: In function `snd_hda_eld_proc_new':
>> (.text+0x1d): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> sound/pci/hda/patch_realtek.o: In function `snd_hda_eld_proc_new':
>> (.text+0x3b): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> sound/pci/hda/patch_cmedia.o: In function `snd_hda_eld_proc_new':
>> (.text+0x0): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> sound/pci/hda/patch_analog.o: In function `snd_hda_eld_proc_new':
>> (.text+0x0): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> sound/pci/hda/patch_sigmatel.o: In function `snd_hda_eld_proc_new':
>> (.text+0x3b): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> sound/pci/hda/patch_atihdmi.o: In function `snd_hda_eld_proc_new':
>> (.text+0x3b): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> sound/pci/hda/patch_conexant.o: In function `snd_hda_eld_proc_new':
>> (.text+0x0): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> sound/pci/hda/patch_via.o: In function `snd_hda_eld_proc_new':
>> (.text+0x0): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> sound/pci/hda/patch_intelhdmi.o: In function `snd_hda_eld_proc_new':
>> (.text+0x3b): multiple definition of `snd_hda_eld_proc_new'
>> sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
>> make[4]: *** [sound/pci/hda/snd-hda-intel.o] Error 1
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> cc: Wu Fengguang <wfg@linux.intel.com>
>> cc: Takashi Iwai <tiwai@suse.de>
>> ---
>>  sound/pci/hda/hda_local.h |    7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Thanks, but these have been differently fixed on the latest ALSA tree.
> snd_print_pcm_*() have to be defined no matter what CONFIG_PROC_FS is.

No problem.  Just for clarification, is linux-next one day behind
your latest tree, or is linux-next using a different branch of it,
or what?


Thanks.
-- 
~Randy
