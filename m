Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZI2K0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZI2K0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZI2K0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:26:03 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:45960 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZI2K0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:26:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEACl9wUrCTtAn/2dsb2JhbACBUNUphB4FgVg
Date: Tue, 29 Sep 2009 12:25:59 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] vfat and
	Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.
Message-ID: <20090929102559.GA4590@frolo.macqel>
References: <20090319181120.GA18034@frolo.macqel> <20090323085024.GA8897@frolo.macqel> <20090323140005.GB25840@frolo.macqel> <20090925194636.GA15700@frolo.macqel> <87vdj2ysk8.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vdj2ysk8.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ogawa,

On Tue, Sep 29, 2009 at 07:05:27PM +0900, OGAWA Hirofumi wrote:
> Philippe De Muyter <phdm@macqel.be> writes:
> 
> > I have an IOMEGA home network hard disk that I can connect either by
> > ethernet (ftp or cifs) or by USB. Because of the ftp server mode
> > firmware, I must keep it formatted as a vfat filesystem.
> >
> > I have copied my music files on it using the ftp mode.  Using the same
> > ftp mode, I can also retrieve my music files without problem, and
> > when I list them, they have the exact names that they had on my linux
> > ext3 partition.
> >
> > When I connected this disk via USB, now relying on the vfat module
> > of linux, there were some directories that I could not reread.  The
> > common factor of these directories names is that they end with one or
> > more dots, e.g.
> >
> > 	Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.
> >
> > If I issue the `ls' or `find' command, I get this strange message :
> >
> > find: ./Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.: No such file or directory
> >
> > Adding printk's in `fat_search_long' revealed that on this disk, the
> > file/directory NAMES ENDING WITH DOTS ARE STORED WITH THEIR TRAILING DOTS.
> >
> > Here is a patch sketch that makes accessing my
> >  Simon_&_Garfunkel-Wednesday_Morning,_3_a.m. directory possible, but I
> > don't know if storing long filenames ending with dot's should not also
> > be fixed.
> 
> IIRC, Windows stripped the trailing ".". That filename can be read/used on
> Windows?

Sorry I don't use MS-Windows.  I'll try to find someone who does.

But, risking repeating myself, the firmware of the IOMEGA disk (via
the ftp interface) presents the filenames with the trailing dots.

> If it can be read, I think we should consider to remove
> vfat_striptail_len() (at least for lookup path), more investigation
> would be needed though.

That's what my patch does actually.  Maybe it should depend of the length
of the filename, though.

Thanks

Philippe
