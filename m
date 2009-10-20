Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbZJTP6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbZJTP6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 11:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZJTP6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 11:58:18 -0400
Received: from xenotime.net ([72.52.64.118]:58791 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751501AbZJTP6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 11:58:18 -0400
Date: Tue, 20 Oct 2009 08:58:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Tilman Schmidt <tilman@imap.cc>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>
Subject: Re: checkpatch.pl false positive?
 "ERROR: do not use assignment in if condition"
Message-Id: <20091020085820.e312a38b.rdunlap@xenotime.net>
In-Reply-To: <4ADDDC55.8020809@imap.cc>
References: <4ADDDC55.8020809@imap.cc>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 17:50:45 +0200 Tilman Schmidt wrote:

> The command
> ./scripts/checkpatch.pl -f drivers/isdn/gigaset/bas-gigaset.c 
> produces a lot of "ERROR" messages like these:
> 
> ERROR: do not use assignment in if condition
> #608: FILE: isdn/gigaset/bas-gigaset.c:608:
> +       if ((ret = usb_submit_urb(ucs->urb_cmd_in, GFP_ATOMIC)) != 0) {
> 
> ERROR: do not use assignment in if condition
> #745: FILE: isdn/gigaset/bas-gigaset.c:745:
> +               if ((ucs->rcvbuf = kmalloc(l, GFP_ATOMIC)) == NULL) {
> 
> ERROR: do not use assignment in if condition
> #753: FILE: isdn/gigaset/bas-gigaset.c:753:
> +               if ((rc = atread_submit(cs, BAS_TIMEOUT)) < 0) {
> 
> As far as I can see there's nothing wrong with these lines. In particular,
> I cannot find anything in Documentation/CodingStyle that would prohibit an
> assignment inside an 'if' condition.

Yes, we don't try to list Every Possible Problem in CodingStyle,
but emails on lkml over the past several years try to discourage such
assignments inside if's because they can be confusing, difficult to read,
and generally are not helping to produce any better code output than
using:
	ret = usb_submit_urb(args);
	if (ret) {
		foo;
		bar;
		blah();
	}

> PS: I know the file has other problems. That's why I'm trying to
> checkpatch it in the first place.



---
~Randy
