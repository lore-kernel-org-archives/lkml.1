Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbXJPIWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbXJPIWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbXJPIVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:21:44 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:41748 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756107AbXJPIVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:21:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Kt12zWz49ONQsTV97avQScuLf327+o7YUbgOrPbotJSeZBaKcE55g1gb7oNJVRsBuCqBzDu/O5n2XpjKl5cQmQEDNKkapiNd+aAYQ+cm41u+R96on1oazL0flu0Vc6i3iqIWvwvvtdWpw+KNGtHmHBWJsnQyYDUK1FfIIvdffyI=  ;
X-YMail-OSG: wE2gtpMVM1nMFcIF_1SPq34Frq7K2alagBpNlIfAyUli10V8Nia0_X3DXwMbxQocazn_B_C42Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [patch][rfc] rewrite ramdisk
Date: Tue, 16 Oct 2007 18:26:55 +1000
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <200710151028.34407.borntraeger@de.ibm.com> <200710161807.41157.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710161015310.10197@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710161015310.10197@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710161826.55834.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007 18:17, Jan Engelhardt wrote:
> On Oct 16 2007 18:07, Nick Piggin wrote:
> >Changed. But it will hopefully just completely replace rd.c,
> >so I will probably just rename it to rd.c at some point (and
> >change .config options to stay compatible). Unless someone
> >sees a problem with that?
>
> I do not see a problem with keeping brd either.

Just doesn't seem to be any point in making it a new and different
module, assuming it can support exactly the same semantics. I'm
only doing so in these first diffs so that they are easier to read
and also easier to do a side by side comparison / builds with the
old rd.c


> >> It also does not seem needed, since it did not exist before.
> >> It should go, you can set the variable with brd.rd_nr=XXX (same
> >> goes for ramdisk_size).
> >
> >But only if it's a module?
>
> Attributes always work. Try vt.default_red=0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
> and you will see.

Ah, nice. (I don't use them much!). Still, backward compat I
think is needed if we are to replace rd.c.
