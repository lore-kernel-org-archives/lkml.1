Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZBDEzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZBDEzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 23:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZBDEy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 23:54:57 -0500
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:43414 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751630AbZBDEy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 23:54:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XiLKoTA5iNEhfUrhNmrYzao5SVwIbpRIa1sb307q2jXu4OTc+g15FEoIVyuK+hcqHD38nrob0cjgqL5l4Yjz25D4OPQYOmquGyHZbgbwsjEESQsZN0lbOdFY9U5WNcjnCGiZgBydyzx7cFyZvehsJ+0PA69Qve9wZRhc8uV4B6U=  ;
X-YMail-OSG: liLKES4VM1lVeWHmFB0gGA7k3hG9X.9NbBGv0Lq_gbvq7zsV29rrXKFvGXbz2mLoyMLL4XJzpXhW6qOlS5cx97I3ipOLgUS_ZOESa0OHXTA467qThlkQL9ZnsB8AmAJplok6RkjmB3M4lzjmni6QOS5X2TqpBKQ7TnQQprH.CCBBw9AfqLbxk.k5vTGhG5g_K_SMbyRUJLdmp7RnocSMA.sufqk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Wed, 4 Feb 2009 15:54:27 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
       davidel@xmailserver.org, davem@davemloft.net, hch@lst.de,
       linux-api@vger.kernel.org, mpm@selenic.com, alan@lxorguk.ukuu.org.uk
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org>
In-Reply-To: <20090203133942.2ecec281.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041554.29184.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 08:39:42 Andrew Morton wrote:
> On Mon,  2 Feb 2009 11:20:09 -0700
>
> Jonathan Corbet <corbet@lwn.net> wrote:
> > Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way
> > of saving space in struct file.  This patch makes that change.
>
> hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
> it doesn't have all the correct/well-understood memory/compiler
> ordering semantics which spinlocks have.

Bit spinlocks are OK now they are using lock bitops. Of course, they are
even nicer (and become very comparable to spinlocks) if you can use the
non-atomic unlock __bit_spin_unlock().

But it seems probably like another approach being discussed is a better
idea anyway.

> And lockdep doesn't know about
> it.

This is a valid concern. Someone had a patch to add lockdep support to it,
which might be a good idea to do. But for small inner locks, maybe not a
huge problem.

