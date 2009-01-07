Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZAGLEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZAGLEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 06:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZAGLD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 06:03:58 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52919 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbZAGLD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 06:03:57 -0500
Date: Wed, 7 Jan 2009 13:03:55 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH][TCP]: simplify tcp_mark_lost_retrans()
In-Reply-To: <Pine.LNX.4.64.0901071229160.27307@wrl-59.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0901071301460.27307@wrl-59.cs.helsinki.fi>
References: <alpine.DEB.2.00.0901071009000.6102@rhea>
 <Pine.LNX.4.64.0901071229160.27307@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1828886473-1231326235=:27307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1828886473-1231326235=:27307
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 7 Jan 2009, Ilpo Järvinen wrote:

> On Wed, 7 Jan 2009, Arnd Hannemann wrote:
> 
> > I noticed
> 
> Good that somebody else is looking TCP code besides me... :-)
> 
> > that in tcp_mark_lost_retrans the for-loop is only entered
> > if tcp_is_fack(tp) evaluates to true:
> > 
> >           if (!tcp_is_fack(tp) || !tp->retrans_out ||
> >               !after(received_upto, tp->lost_retrans_low) ||
> >               icsk->icsk_ca_state != TCP_CA_Recovery)
> >                   return;
> > 
> > Therefore the following check in the for-loop seems to be redundant,
> > because it always evaluates to true:
> > 
> >                      (tcp_is_fack(tp) ||
> >                       !before(received_upto,
> >                               ack_seq + tp->reordering * tp->mss_cache))
> > 
> > Did I miss something?
> 
> It was just a left over from the RFC3517 SACK addition which added that 
> !tcp_is_fack(tp) there above. ...It would have been nice to have similar 
> lost rexmit feature without FACK as well but calculating that wasn't 
> trivial (or I didn't find that too trivial) and could end up being 
> extremely expensive in case of large holes. (So I also left it there as 
> sort of reminder).
> 
> On the second thought, it would be possible to count skbs we pass while 
> walking from the beginning and use that a remaining_sacked counter 
> to get rid of all heurestics too and base the counting only on sacked 
> stuff which aligns with the spirit of rfc3517 much better than 
> sacked+holes used by fack.

Nah, tried to do that that wasn't working nicely either... Since there is 
a need to know how many sack blocks reside between ack_seq and 
received_upto, not the number of sack blocks between skb and 
received_upto...

-- 
 i.
---696208474-1828886473-1231326235=:27307--
