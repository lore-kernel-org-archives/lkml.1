Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbZALTsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbZALTsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZALTsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:48:21 -0500
Received: from yop.chewa.net ([91.121.105.214]:36674 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752AbZALTsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:48:19 -0500
From: =?iso-8859-1?q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Organization: Remlab.net
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: RFC: Network privilege separation.
Date: Mon, 12 Jan 2009 21:47:57 +0200
User-Agent: KMail/1.9.9
Cc: Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <12821.1231785850@turing-police.cc.vt.edu> <20090112194333.GB23848@one.firstfloor.org>
In-Reply-To: <20090112194333.GB23848@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901122147.57731.rdenis@simphalempin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 janvier 2009 21:43:33 Andi Kleen, vous avez écrit :
> > Yes, the network access part *is* something that should be part of a more
> > general interface.  Having said that, we currently are lacking a way for
> > a *general user* program to say "I'm all set up, and would like to
> > disavow any other further resource access (except maybe r/o access as
> > "other" to file systems)".
>
> seccomp does exactly that. It's quite obscure, but available in most
> linux kernels. Basically it blocks everything except
> read/write on already open file descriptors.
>
> I always thought it would be nice if codecs (which tend
> to be full of security holes) ran in such jails by default

Yeah, and there are not going to do that because there are lots of useful 
stuff codecs like to do that represents no security issue but is nevertheless 
impossible with SECCOMP (according to the documentation).

Expanding the heap, mapping memory. Getting timestamps. Waiting on futexes, 
catching signals, polling file descriptors. Seeking, doing vectorized I/O. 
Cloning.


Codecs don't like to read/write raw video through a pipe...

-- 
Rémi Denis-Courmont
http://www.remlab.net/
