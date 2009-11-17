Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbZKQNuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbZKQNuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 08:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZKQNuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 08:50:11 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:43041 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZKQNuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 08:50:10 -0500
Date: Tue, 17 Nov 2009 14:50:03 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
       alsa-devel@alsa-project.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Wu Zhangjin <wuzj@lemote.com>
Subject: Re: [PATCH] MIPS: Fixups of ALSA memory maps
Message-ID: <20091117135003.GB27085@linux-mips.org>
References: <9cbcd06037c18288a6493459b8f3a6e1562eca77.1258389992.git.wuzhangjin@gmail.com> <20091116170641.GD14948@linux-mips.org> <s5hbpj2ie8p.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hbpj2ie8p.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 06:14:14PM +0100, Takashi Iwai wrote:

> > > Seems this is MIPS specific, but it's not that easy to move this patch
> > > into the arch/mips part, So, any better solution?
> > > 
> > > Thanks & Regards,
> > >        Wu Zhangjin
> > > 
> > > ------------------------
> > > 
> > > The user application mmap audio dma regions must be dma-coherent. This
> > > patch fix it.
> > > 
> > > Without this patch, artsd will fail on boot, and mplayer will exit with
> > > "Segmentation fault". (this happens on YeeLoong netbook, fuloong2f
> > > mini pc with snd_cs5535 audio card)
> > > 
> > > This is originally from the to-mips branch of
> > > http://dev.lemote.com/code/linux_loongson, and contributed by Yanhua
> > > from Lemote Inc.
> > > 
> > > Reported-by: qiaochong <qiaochong@gmail.com>
> > > Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
> > 
> > This issue is an old ghost still around, see:
> > 
> >    http://www.linux-mips.org/cgi-bin/mesg.cgi?a=linux-mips&i=20060124.132832.37533152.nemoto%40toshiba-tops.co.jp
> > 
> > which is a superset of your proposed patch and which itself is refering to
> > an even older posting from 2003:
> > 
> >    http://www.linux-mips.org/cgi-bin/mesg.cgi?a=linux-mips&i=20030523215935.71373.qmail%40web11901.mail.yahoo.com
> > 
> > The #ifdef'ed solution doesn't cut it for sure.  Let's see what better we
> > can find ...
> 
> Indeed.  My preference option is to deploy dma_mmap_coherent() to
> possible architectures and use it commonly in the ALSA core code.
> 
> But, as a temporary workaround, I'm fine with ifdef until the API is
> defined...

There is a MIPS platform which may be based on a variety of system
controllers only one of which supports cache coherency.  So we want to
deciede at runtime not at compile time.

  Ralf
