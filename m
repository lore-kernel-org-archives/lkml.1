Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbXLIG5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbXLIG5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 01:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXLIG5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 01:57:11 -0500
Received: from smtp115.plus.mail.re1.yahoo.com ([69.147.102.78]:45011 "HELO
	smtp115.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751057AbXLIG5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 01:57:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Pk/g5PflT19uCWG3Fpb1qv0/aHa4b2nT3FFyT3rJ0sEMMVO7NiQz+JODPDaZslN/sW3JhPyyv6Wh8t016qxOBlZI0M8tUyR14q6AQwMYxGIj7k0ZldQqPAn2I46xNrrR5e66kEcWvlQRW/iPN99v1bocmkQa79lg9mbfoDg3+JA=  ;
X-YMail-OSG: 8yYBmPQVM1kWZUyAWy8O3GTU4IBsN6wSryKURvvolClJZfaqE0gF7lbNfPi9tBc7krhYWnZxaw--
Date: Sun, 9 Dec 2007 07:55:59 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] swap image signature check upon resume
Message-ID: <20071209065559.GA4627@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
References: <20071206211335.GA4923@gollum.tnic> <200712072119.09836.rjw@sisk.pl> <20071208113306.GA7573@gollum.tnic> <200712082350.33626.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712082350.33626.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 11:50:33PM +0100, Rafael J. Wysocki wrote:
> On Saturday, 8 of December 2007, Borislav Petkov wrote:
> > On Fri, Dec 07, 2007 at 09:19:09PM +0100, Rafael J. Wysocki wrote:
> > 
> > ...
> > 
> > > > > Well, there's a patchset in the current mainline that allows you to use
> > > > > arbitrary (sufficiently new) kernel to load the image and then restore the
> > > > > image kernel.  So, you can hibernate 2.6.24-rc3 and use 2.6.24-rc2 to restore
> > > > > it, for example.
> > > > > 
> > > > > I'm going to do that for i386 too.
> > > > right, this is d307c4a8e826c44f9633bd3f7e60d0491e7d885a (Hibernation: Arbitrary
> > > > boot kernel support - generic code), i should've seen that. What's the status of
> > > > those bits, from a quick scan it seems they need some rewiring (Kconfig, e.g.
> > > > CONFIG_ARCH_HIBERNATION_HEADER etc..) and arch-specific save and restore
> > > > functions?
> > > 
> > > No, this code is fully functional. :-)
> > > 
> > > The arch save and restore functions are in arch/x86/kernel/suspend_64.c .
> > > 
> > > As I said, i386 is not yet supported.
> > 
> > nice, holler if you need a tester when you have some prototypes ready. By the way,
> > what do you do when the suspend image header mismatches and it is unsafe to continue booting?
> 
> If the image header doesn't match, we don't load it and return an error code,
> which usually results in the boot kernel continuing to boot.

But if you continue to boot the filesystems were still mounted and fsck has to
go over them and check for errors. In the case of ext2 this takes relatively
long depending on the size of the partition. However, this is only the
smaller problem, the problem of data loss is what worries me.

Instead, I'd rather issue a warning that the swsusp header mismatches, say with
which kernel the machine got suspended with and then start the countdown for reboot.
Thoughts?

-- 
Regards/Gruﬂ,
    Boris.
