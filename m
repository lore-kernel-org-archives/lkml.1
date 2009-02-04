Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZBDHVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZBDHVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 02:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZBDHVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 02:21:04 -0500
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:44443 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751277AbZBDHVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 02:21:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2kiy1hUIrfap12ONeVcqEx7oNHF4q8djiIGsCKk96FqlLquu0GRaVkhtgqcYU3hB3u7RJECmmXLKDeOxqWmvew/p3Ub5RjKFVWrzLe6E+ikJMJ+Vi8P7Mlp3z/vW8X9EDdNse+6k3PkvDY1lTQ+GR4u3ZSk//N25MT3PpiwKLbc=  ;
X-YMail-OSG: wssAblUVM1kcZpOaUo9t_Vl13fJFs62nq.gPsvAdODJrWTcDeYJPh5863UlDNGrLAycw48wG40yuccynkoy8UzA3Al5IfBKOBUlFEa_WLozXg4JVadwx.Kh.VSdwRy0d.c7UjKce1GALTKAFWgKScMFAtBeaKl.REiXNZD3sbI2pdHdGWN6SIAj6wo0ifw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Wed, 4 Feb 2009 18:20:18 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Jonathan Corbet <corbet@lwn.net>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       dada1@cosmosbay.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
       oleg@redhat.com, viro@zeniv.linux.org.uk, davidel@xmailserver.org,
       davem@davemloft.net, linux-api@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <20090203161931.4054a25e@bike.lwn.net> <20090204071320.GA19348@lst.de>
In-Reply-To: <20090204071320.GA19348@lst.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041820.20535.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 18:13:20 Christoph Hellwig wrote:
> On Tue, Feb 03, 2009 at 04:19:31PM -0700, Jonathan Corbet wrote:
> >  1) Use i_lock to protect accesses to f_flags.  This would enable some
> >     BKL usage to be removed, but would not fix fasync.
>
> What about just turning f_ep_lock into f_lock and using it?

Ah, yes I was going to say that too, but I confused i_lock with i_mutex
because it sounded like Jon needed a sleeping lock here?

Agree f_lock would be good. It might come in handy for other things too.

