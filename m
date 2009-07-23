Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZGWGB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZGWGB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZGWGB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:01:26 -0400
Received: from nschwmtas05p.mx.bigpond.com ([61.9.189.149]:63578 "EHLO
	nschwmtas05p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbZGWGB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:01:26 -0400
X-Greylist: delayed 18704 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jul 2009 02:01:25 EDT
Date: Thu, 23 Jul 2009 15:31:22 +0930
From: Alan Modra <amodra@bigpond.net.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Matthias Klose <doko@ubuntu.com>, binutils <binutils@sourceware.org>,
       Bastian Blank <waldi@debian.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kiko Piris <kernel@pirispons.net>,
       Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>
Subject: Re: current binutils trunk fails to build bootable kernel image
	for some configurations
Message-ID: <20090723060122.GI13233@bubble.grove.modra.org>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Matthias Klose <doko@ubuntu.com>,
	binutils <binutils@sourceware.org>,
	Bastian Blank <waldi@debian.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Kiko Piris <kernel@pirispons.net>,
	Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
	Wolfgang Walter <wolfgang.walter@stwm.de>
References: <4A6746B9.9010603@ubuntu.com> <20090723004939.GF13233@bubble.grove.modra.org> <20090723050522.GA8887@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090723050522.GA8887@merkur.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150204.4A67FCB3.0080,ss=1,fgs=0
X-SIH-MSG-ID: rhg2Gdf3TAD0zmRy0WWwOwRzyFrsq3B48Z4QWs1mqRMGT0XduMfOJ5LmY9kEnZ7k1y5MMBCFP2siYLzmXY/YiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 07:05:22AM +0200, Sam Ravnborg wrote:
> On Thu, Jul 23, 2009 at 10:19:39AM +0930, Alan Modra wrote:
> >   .data_nosave ALIGN(PAGE_SIZE) : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
> 
> Do you recall when this started to be supported?

Forever.

> I think I tried this and it failed - but I may be wrong here.

I can think of at least two things that might cause my suggestion to
fail.
1) .data_nosave input sections may have alignments greater than
PAGE_SIZE, but we're setting the start address explicity.
2) following sections won't be aligned to PAGE_SIZE if .data_nosave is
empty.

Hmm, there is another option that I'd forgotten about.

  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {

This avoids (1) above since it only increases alignment.  Support for
this form of alignment was added 2005-09.

> Also - do there exist an option to tell what sections has not been
> covered by a linker script?

No.  You could put

  /DISCARD/ : { *(*) }

at the end of your script, then generate a map file.  Discarded
sections are reported.

-- 
Alan Modra
Australia Development Lab, IBM
