Return-Path: <linux-kernel-owner+w=401wt.eu-S1760500AbYGOQhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbYGOQhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761918AbYGOQhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:37:36 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:23479 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761901AbYGOQhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:37:35 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Tue, 15 Jul 2008 18:37:31 +0200
User-Agent: KMail/1.9.9
Cc: jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <200807151757.10626.elendil@planet.nl> <alpine.LFD.1.10.0807150913590.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807150913590.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151837.32770.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jul 2008 16:37:33.0212 (UTC) FILETIME=[14B91DC0:01C8E699]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008, you wrote:
> On Tue, 15 Jul 2008, Frans Pop wrote:
> > So, how is this solved by Debian for already existing firmware
> > packages? Basically by making a separate package for each firmware
> > file (or driver). This works because there are not too many of them,
> > but having a huge number of tiny packages is a nightmare by itself.
>
> Why don't you just take the kernel-supplied firmware and make it part
> of the kernel package? The same way the kernel-supplied modules are
> part of it?

Important note: this is not me, this is the Debian kernel team based on 
Debian Free Software Guidelines (DFSG). If it were purely up to me I'd be 
a lot more pragmatic.

1) Because Debian _wants_ them split out for DFSG compliance reasons.
Most of the current firmware packages are kept in the "non-free" section 
of the Debian archive while the kernel itself lives in "main".
As long as firmware could not be split out, the compliance problem was the 
source of many discussions, but for the most part ignored in practice, 
with the exception of a few drivers with really problematic firmware 
licences.

2) Because of the overwrite and version management problems.
/lib/firmware as a single dumping ground for firmware for all kernel 
versions really sucks from that PoV. One of the huge strengths of Debian 
is its ability to clean up after itself when packages are removed.
This is partially solved by giving each firmware file it's own package 
because then you can use the versioning of the firmware itself in the 
package versions, which allows proper file management by the packaging 
system. But as I said, I'm not sure that still works if their number 
suddenly explodes.
