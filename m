Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbZJTQYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbZJTQYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZJTQYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:24:03 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36323 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZJTQYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:24:02 -0400
Date: Tue, 20 Oct 2009 17:24:00 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch.pl false positive? "ERROR: do not use assignment in
 if condition"
Message-ID: <20091020162400.GF13064@penfold>
References: <4ADDDC55.8020809@imap.cc>
 <20091020085820.e312a38b.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020085820.e312a38b.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 08:58:20AM -0700, Randy Dunlap wrote:
> On Tue, 20 Oct 2009 17:50:45 +0200 Tilman Schmidt wrote:
> 
> > The command
> > ./scripts/checkpatch.pl -f drivers/isdn/gigaset/bas-gigaset.c 
> > produces a lot of "ERROR" messages like these:
> > 
> > ERROR: do not use assignment in if condition
> > #608: FILE: isdn/gigaset/bas-gigaset.c:608:
> > +       if ((ret = usb_submit_urb(ucs->urb_cmd_in, GFP_ATOMIC)) != 0) {
> > 
> > ERROR: do not use assignment in if condition
> > #745: FILE: isdn/gigaset/bas-gigaset.c:745:
> > +               if ((ucs->rcvbuf = kmalloc(l, GFP_ATOMIC)) == NULL) {
> > 
> > ERROR: do not use assignment in if condition
> > #753: FILE: isdn/gigaset/bas-gigaset.c:753:
> > +               if ((rc = atread_submit(cs, BAS_TIMEOUT)) < 0) {
> > 
> > As far as I can see there's nothing wrong with these lines. In particular,
> > I cannot find anything in Documentation/CodingStyle that would prohibit an
> > assignment inside an 'if' condition.
> 
> Yes, we don't try to list Every Possible Problem in CodingStyle,
> but emails on lkml over the past several years try to discourage such
> assignments inside if's because they can be confusing, difficult to read,
> and generally are not helping to produce any better code output than
> using:
> 	ret = usb_submit_urb(args);
> 	if (ret) {
> 		foo;
> 		bar;
> 		blah();
> 	}
> 
> > PS: I know the file has other problems. That's why I'm trying to
> > checkpatch it in the first place.

What he said :).  We try and codify the preferred style where there is
a preference.  That preference was made by reviewers as it is much
harder to accidentally do the following when you meant the assignment or
visa versa:

    if ((rc == foo) < 10)

-apw
