Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZCBX3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZCBX3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZCBX3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:29:13 -0500
Received: from n11b.bullet.mail.mud.yahoo.com ([209.191.125.178]:27069 "HELO
	n11b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751236AbZCBX3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:29:12 -0500
X-Yahoo-Newman-Id: 406466.75848.bm@omp419.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ulI5c4+QAv1/oPISooibsHucnE51m49vXfNwtN6Okt8wIS1+AVHAB8QOIO0tYcTLGSsmDhGooUdEXFMnpMtgFKe309DjCxZdg8iifeo5T1i4PQMgi4VRu0McgDhniNvKO6Zi4DLU610gkY4ZC+9kPaBkH2hkfdRFXoqsZVgchFM=  ;
X-YMail-OSG: iql46okVM1mC4ums6142F.YgQAq2d56ATjurknTQNM4nDN.284w_65Pblw.UE4aRsbdjJSyITwJhqg4V4DzMWYRNw9Z6WRS5zniID9CgiypP3EkkTav04AMTKtgGX225eLVVBjZZBgapC4aXy9xiS.Zb
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Mon, 2 Mar 2009 15:29:07 -0800
User-Agent: KMail/1.9.10
Cc: dbrownell@users.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021440.58712.david-b@pacbell.net> <1236034289.5330.1745.camel@laptop>
In-Reply-To: <1236034289.5330.1745.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021529.07894.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Peter Zijlstra wrote:
> > But if that's what is keeping you from fixing the lockdep bug,
> > why haven't you submitted patches to remove IRQF_DISABLED from
> > the kernel, and update all the drivers relying on IRQs being
> > enabled when their handlers run?
> 
> I did so today. Just didn't realize things actually relied on it since
> lockdep turned them off and my system has been working fine.

That patch did no such thing.  It added a BUG_ON(),
which has nothing to do with removing IRQF_DISABLED.


> Your driver needs threaded interrupts, Thomas is working on that now,
> and I saw a conversion of your driver to use that.

Thomas hasn't yet touched the issue of how to chain such IRQs
though ... I consider his v2 patches a decent start, with some
limitations that could be attributed to an x86 focus.


> IDE PIO can hopefully also be converted to threaded interrupts.

I have worked with ARMs with IDE support.  That's become
rare in new chips though, even for CF cards; it needs too
many signal wires.

- Dave


