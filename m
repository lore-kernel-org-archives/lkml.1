Return-Path: <linux-kernel-owner+w=401wt.eu-S933467AbYA2UlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbYA2UlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbYA2UlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:41:14 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:10309 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385AbYA2UlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:41:12 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <479F71B6.2010305@zytor.com>
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
	 <479E5D22.1070109@goop.org>
	 <1201599251.5301.26.camel@localhost.localdomain>
	 <479F6845.1070902@goop.org> <479F6AD2.8050908@zytor.com>
	 <479F70E9.40905@goop.org>  <479F71B6.2010305@zytor.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 20:38:32 +0000
Message-Id: <1201639112.9516.23.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 10:34 -0800, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> > H. Peter Anvin wrote:
> >> It's also easy enough to either use objdump -h or nm to extract info 
> >> from vmlinux; or for some of the simpler stuff, just parse the ELF 
> >> directly (perhaps using libelf).
> >>
> >> There is also the -R option to ld, which imports symbols from one 
> >> executable into another. 
> > 
> > Yes, I used -R, though it was necessary to generate a copy of vmlinux 
> > with a filtered symbol list to prevent collisions.  But I'm not sure any 
> > of this is necessary with Ian's approach.
> > 
> 
> Probably isn't.  He just need the start and possibly length of the 
> payload section, which should be objdump -h or equivalently reading the 
> ELF section table.

I'm currently using "objcopy --extract-symbol -w -N \* -K input_data" to
create a .o with just the symbol I'm interested in and using -R on that.
There's also an option to add a prefix to all symbols which might be
useful.

I finessed the length issue slightly since it happens that the word
before the payload is the payload's length. I'm mulling a variety of
options:
      * declare it compression scheme dependant. At least for gzip it
        knows when it has reached the end.
      * codify the length followed by data thing we happen to have now
      * add a length field to the header, using another 4 bytes (is
        there any pressure on the size of the header?).

I'd probably go with the later unless we are pressed for space in the
header.

Ian.
-- 
Ian Campbell

Man who falls in vat of molten optical glass makes spectacle of self.

