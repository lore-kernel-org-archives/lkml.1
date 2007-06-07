Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbXFGQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbXFGQIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbXFGQI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:08:26 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58451
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbXFGQIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:08:25 -0400
From: Rob Landley <rob@landley.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
Date: Thu, 7 Jun 2007 12:08:04 -0400
User-Agent: KMail/1.9.1
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <20070606225837.654272428@goop.org> <200706062147.21225.rob@landley.net> <46676552.4060308@zytor.com>
In-Reply-To: <46676552.4060308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071208.04777.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 9:54 pm, H. Peter Anvin wrote:
> Rob Landley wrote:
> > On Wednesday 06 June 2007 7:41 pm, H. Peter Anvin wrote:
> >> This makes vmlinux (normally stripped) recoverable from the bzImage file
> >> and so anything that is currently booting vmlinux would be serviced by
> >> this scheme.
> > 
> > Would this make it sane to strip the initramfs image out of vmlinux with 
> > objdump and replace it with another one, or are there offsets resolved 
during 
> > the build that stop that for vmlinux?
> > 
> 
> There probably are offsets resolved during the build.  However, that
> wouldn't be all that hard to fix.  Still, one can argue whether or not
> it is sane under any definition to do this kind of unpacking-repacking
> of ELF files.

Er, make that objcopy, not objdump.

Sane, maybe not.  Something people want to do (and under the mistaken 
assumption I know more about initramfs then they do, have asked me how), yes.  
It always boils down to "do you have a vmlinux image lying around?  Doing 
this with a bzImage _is_ brain surgery", and has yet to get beyond that 
question.  I had about half of a script worked out for this, once...

You can also supply an external initramfs image through the initrd mechanism, 
but this is unpleasant to do with some bootloaders (or lack of bootloaders).  
Plus it doesn't remove the old one, and wasting space makes embedded 
developers itch.

Rob
-- 
The Google cluster became self-aware at 2:14am EDT August 29, 2007...
