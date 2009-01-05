Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZAEMAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZAEMAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZAEMAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:00:43 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:44774 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752656AbZAEMAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:00:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GyrBMMtlchAsDLEOKGF4+YitCK/e239AAJhCzgOxLlCTOWonMtthsbQrfz0gW1EVrqMbKX7Najr3bM49c/5TjrlNbGJFvGqywllEF6QhF3LEABkncCk2ETN2pEpQXd8vSelhECwl+hqcGVfzn2U7ymNVF0f14UWjf1YOqF/Er80=  ;
X-YMail-OSG: luT0f.MVM1nTXetOKbqbntbRbubTwe03bGMPtQ42vmYY1p1alA9oQxWnGAYnXXGAgMapipdFIY162ucW6QFzBZX4hcKB9s55PtuEx9S4D588bH7ZOT_VA7RaqD5WX5AEIU_Rj0J9cwtd8YtIufgPM2G.B4qrrY1d9yDLvyqi2ZuQrFiLy3.TVRoXdVqOFMY_dbKY8IsUdRKMvEcpwbBNUoanCwJP
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, paulmck@us.ibm.com
Subject: Re: atomics: document that linux expects certain atomic behaviour from unsigned long
Date: Mon, 5 Jan 2009 23:00:24 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103124400.GA1572@ucw.cz> <200901052154.45958.nickpiggin@yahoo.com.au> <20090105112350.3e665114@lxorguk.ukuu.org.uk>
In-Reply-To: <20090105112350.3e665114@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901052300.24951.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009 22:23:50 Alan Cox wrote:
> > Pretty much everywhere that uses RCU for example does so using atomic
> > pointer loads and stores. The nastiest issue IMO actually is reloading
> > the value through the pointer even if it isn't explicitly dereferenced.
> > RCU gets this right with ACCESS_ONCE. Probably a lot of code using basic
> > types does not. x86 atomic_read maybe should be using ACCESS_ONCE too...
>
> I'm pretty sure it should. gcc makes no guarantees about not being clever
> with accesses.

Arguably it should. I don't know what the concurrent C standard looks like,
but prohibiting reloads of potentially concurrently modified memory when
there is no explicit pointer dereference is the natural complement to
prohibiting stores to potentially concurrently read memory when there is
no explicit store (which I think is begrudgingly agreed to be a problem).

http://lkml.org/lkml/2007/10/24/673

I think I would like to see multiple reloads to local variables prohibited,
to avoid potential really subtle problems... But if ACCESS_ONCE is here to
stay, then I do think that atomic_read etc should use it.

