Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZC3C2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZC3C2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 22:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbZC3C2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 22:28:21 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:53446 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbZC3C2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 22:28:20 -0400
In-Reply-To: <200903272153.05622.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 5/13] score - New architecure port to SunplusCT S+CORE processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFBA5A0860.CDC7D821-ON48257589.000CDE82-48257589.000D7C1F@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 30 Mar 2009 10:25:26 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/30 ?? 10:25:29,
	Serialize complete at 2009/03/30 ?? 10:25:29
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2U2Shqu000542

Hi tglx, Arnd, Kyle and Sam,

        Thank you for your kindly reply, I will update 
        the code according to your comments.
        The fixed patches will be sent out soon.

-- 
Best regards
Liqin
liqin.chen@sunplusct.com

Arnd Bergmann <arnd@arndb.de> Ð´ÓÚ 2009-03-28 04:53:05:

> On Friday 27 March 2009, Sam Ravnborg wrote:
> 
> > Thats strange indeed.
> > This structure will then change layout depending on the target 
bit-size
> > of the compiler.
> > 
> > From x86:
> > #ifdef __i386__
> >         unsigned long           __unused1;
> > #endif
> >         __kernel_time_t         shm_dtime;      /* last detach time */
> > #ifdef __i386__
> >         unsigned long           __unused2;
> > #endif
> > 
> > long is 64 bit in one case and 32 bit in another case.
> > I'm confused..
> 
> The idea here is to have the same layout for both by adding
> long (32 bit) padding between 32 bit members on i386 and not
> having the padding along the __kernel_time_t (which is also
> long) members on x86_64. The problem is that some architectures
> copying this didn't understand the part about the padding,
> while others (big-endian ones) put the padding in the wrong
> place by copying from i386.
> 
> By now, most of the existing architectures copied the i386
> file, which is at least consistent and we've learned to
> deal with it. I recommend just using this one as the
> asm-generic version and letting all new archs fall back
> to that.
> 
> > I would expect it to be safer to be bit-size neutral in our
> > exported headers.
> > But the score people know there userlend best so let them decide.
> 
> > Still they should audit all their exported headers.
> > They cannot assume it was right because they copied them from
> > somewhere.
> 
> Yes, I agree. Hopefully I'll manage to get my patches into
> shape to post the generic versions in the next days so we can use
> them on microblaze and score as well as all future versions.
> 
>    Arnd <><

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
