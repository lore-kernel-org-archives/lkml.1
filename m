Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYKUKAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYKUKAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYKUKAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:00:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40695 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752799AbYKUKAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:00:30 -0500
Date: Fri, 21 Nov 2008 10:00:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
Message-ID: <20081121100035.3f5a640b@lxorguk.ukuu.org.uk>
In-Reply-To: <49260E4C.8080500@caviumnetworks.com>
References: <49260E4C.8080500@caviumnetworks.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 17:26:36 -0800
David Daney <ddaney@caviumnetworks.com> wrote:

> MIPS: Make BUG() __noreturn.
> 
> Often we do things like put BUG() in the default clause of a case
> statement.  Since it was not declared __noreturn, this could sometimes
> lead to bogus compiler warnings that variables were used
> uninitialized.
> 
> There is a small problem in that we have to put a magic while(1); loop to
> fool GCC into really thinking it is noreturn.  

That sounds like your __noreturn macro is wrong.

Try using __attribute__ ((__noreturn__))

if that works then fix up the __noreturn definitions for the MIPS and gcc
you have.

