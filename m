Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXJUVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXJUVJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbXJUVJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 17:09:08 -0400
Received: from mail.musicgenome.com ([212.150.69.147]:33134 "EHLO
	mail.musicgenome.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbXJUVJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 17:09:07 -0400
Date: Sun, 21 Oct 2007 22:53:29 +0200
From: Tal Kelrich <tal@musicgenome.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.4/2.6 local TCP connect oddity
Message-ID: <20071021225329.1a971751@shodan.orpak.com>
In-Reply-To: <20071021172901.GV10199@1wt.eu>
References: <20071021175337.605e843e@shodan.orpak.com>
	<20071021172901.GV10199@1wt.eu>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.6.10; i686-redhat-linux-gnu)
X-Habeas-SWE-1: winter into spring
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Musicgenome-MailScanner-Information: Please contact the ISP for more information
X-Musicgenome-MailScanner: Found to be clean
X-Musicgenome-MailScanner-SpamCheck: not spam, SpamAssassin (score=-5.899,
	required 6, autolearn=not spam, ALL_TRUSTED -3.30, BAYES_00 -2.60)
X-Musicgenome-MailScanner-From: tal@musicgenome.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 19:29:02 +0200
Willy Tarreau <w@1wt.eu> wrote:

> Hi,
> 
> On Sun, Oct 21, 2007 at 05:53:37PM +0200, Tal Kelrich wrote:
> > Hi,
> > 
> > I've run into a problem where a process trying to connect to a local
> > port within the local port range eventually ends up connected to
> > itself, with source port = dest port.
> > 
> > similar behavior can be gotten by running netcat as follows:
> > nc -p 1025 localhost 1025
> > 
> > I'm not really sure if that's a bug, but the original case was at
> > least unexpected.
> 
> It is not a bug, it is caused by the "simultaneous connect" feature of
> TCP. Although rarely used, in TCP you can connect two clients
> together. They just have to exchange their SYN, SYN/ACK then ACK and
> bingo, they're connected. In fact, you found the easiest way to
> achieve it, by using the same port. To demonstrate the feature, I'm
> used to either temporarily block SYNs with iptables, or by unplugging
> the cable between two machines.
> 

Hi,

It still seems confusing that a connect against localhost may
randomly succeed.

Here's a better example, if somewhat violent. eventually succeeds.
(p=$((`cat /proc/sys/net/ipv4/ip_local_port_range|cut -f1`+1)); while
true ; do nc -v -v 127.0.0.1 $p ; done)

Regards,
	Tal

-- 
Tal Kelrich
PGP fingerprint: 3EDF FCC5 60BB 4729 AB2F  CAE6 FEC1 9AAC 12B9 AA69
Key Available at: http://www.hasturkun.com/pub.txt
----
We are each entitled to our own opinion, but no one is entitled to his
own facts.
		-- Patrick Moynihan
----
