Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbXBEQfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbXBEQfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXBEQfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:35:51 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:53917 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbXBEQfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:35:50 -0500
Date: Mon, 5 Feb 2007 08:30:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Liontooth <liontooth@cogweb.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Eeek! page_mapcount(page) went negative! (-1)
Message-Id: <20070205083052.89d59376.randy.dunlap@oracle.com>
In-Reply-To: <45C6CA72.6020206@cogweb.net>
References: <45C698D1.1070208@cogweb.net>
	<45C6B71E.9050805@cogweb.net>
	<20070204211705.8cd3203b.randy.dunlap@oracle.com>
	<45C6CA72.6020206@cogweb.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Feb 2007 22:10:58 -0800 David Liontooth wrote:

> Randy Dunlap wrote:
> > On Sun, 04 Feb 2007 20:48:30 -0800 David Liontooth wrote:
> >
> >   
> >> David Liontooth wrote:
> >>     
> >>>   
...[snippage]
> >>>       
> >> More from the same machine -- it really doesn't like the script, which
> >> simply does:
> >>
> >> nice -n 19 transcode -q 0 -o $FIL.img/$FIL.img -y im -F png -x
> >> ffmpeg,null -i $FIL.avi -c \
> >> 0:00:00-0:00:00.1,0:00:10-0:00:10.1,0:00:20-0:00:20.1,0:00:30-0:00:30.1,0:00:40-0:00:40.1,0:00:50-0:00:50.1,\
> >> 0:01:00-0:01:00.1,0:01:10-0:01:10.1,0:01:20-0:01:20.1,0:01:30-0:01:30.1,0:01:40-0:01:40.1,0:01:50-0:01:50.1
> >>
> >> nice -n 19 convert -thumbnail 80x60 $IMG.png $THUMBS/$IMG.jpg
> >>
> >> nice -n 19 montage -tile 15 -geometry +1,+1 $FIL.img/$THUMBS/*.jpg $FIL.jpg
> >>
> >> I run the same script on another machine without drama.
> >>
> >> Any suggestions? Please cc: me.
> >>     
> >
> >
> > Two things:
> > a.  Can you try a recent/current kernel to see if this happens?
> > b.  The "Tainted: GF" means that a module was forcibly loaded.
> > What module was this?  and is it compatible with a 2.6.16.38 kernel?
> > Can you reproduce this problem without having that module loaded?
> >   
> Randy, thanks for responding. I discovered that the files the script was
> operating on were corrupt, so let me see if it recurs with healthy files.
> 
> It's the lirc module that generates the GF flag --
> 
>     lirc_serial: no version for "lirc_unregister_plugin" found: kernel
> tainted.
> 
> So it's not actually forced. I'll remove it if this problem recurs.
> 
> I've tried 2.6.18 and 2.6.19 on this box, and they are moderately stable
> if I use acpi_use_timer_override. It's a production machine, so I can't
> experiment much.

Hi Dave,

Don't just remove the lirc module(s).  They need to have never been
loaded at all.

---
~Randy
