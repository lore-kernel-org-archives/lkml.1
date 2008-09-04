Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYIDMfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYIDMfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYIDMe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:34:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41993 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752326AbYIDMe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:34:56 -0400
Date: Thu, 4 Sep 2008 13:34:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de, hpa@zytor.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080904133419.3704490b@lxorguk.ukuu.org.uk>
In-Reply-To: <873akgw251.fsf@basil.nowhere.org>
References: <20080903195122.73905236@infradead.org>
	<873akgw251.fsf@basil.nowhere.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 14:01:46 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > Add basic sanity checks to the syscall execution patch
> 
> This just means that the root kits will switch to patch
> the first instruction of the entry points instead.
> 
> So the protection will be zero to minimal, but the overhead will
> be there forever.

Agreed entirely. This is a waste of time and a game not worth playing.
The only place you can expect to make a difference here is in virtualised
environments by teaching KVM how to provide 'irrevocably read only' pages
to guests where the guest OS isn't permitted to change the rights back or
the virtual mapping of that page.

Alan
