Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbYCVS4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbYCVS4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYCVS4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:56:25 -0400
Received: from lazybastard.de ([212.112.238.170]:42811 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbYCVS4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:56:24 -0400
Date: Sat, 22 Mar 2008 19:56:01 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: dwmw2 <dwmw2@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-sh <linux-sh@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Paul Mundt <lethal@users.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] 2/3 mtd: add support for flash on the SEGA Dreamcast Visual Memory Unit
Message-ID: <20080322185600.GE19347@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206209035.6324.29.camel@localhost.localdomain> <20080322183200.GD19347@logfs.org> <1206211147.6324.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1206211147.6324.48.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 March 2008 18:39:07 +0000, Adrian McMenamin wrote:
> On Sat, 2008-03-22 at 19:32 +0100, Jörn Engel wrote:
> 
> > Given that you have ignored most of my previous comments, NAK. 
> 
> Not good enough, frankly. What comments have I ignored? I didn't
> implement your suggestion that a void* memory type become be32* because
> it was totally inappropriate for a type that is passed in both be32 and
> le32 and as u8.

Your argument would make sense if referring to a transport layer where
some structure is just passed along as payload data.  But you are
dereferencing a structure.  And instead of declaring a structure, you
still do this:
	((unsigned long *)sendbuf)[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
	((unsigned long *)sendbuf)[1] = cpu_to_be32(partition << 24 | num);

If that is a valid description of "appropriate" in your dictionary then
we clearly don't speak the same language.  Even your own suggestion to
change the cast to (u32*) would have been an improvement.

> I'm sorry that you feel that way, but as you took the hump when I said
> that this:
> 
> "Possibly the big-endian annotations need to trickly though the layers
> here as well."
> 
> Isn't good english (and it's not) and asked you - twice - to explain
> what you meant. I cannot accept your summary.

s/trickly/trickle/

I tried to help you by a) reviewing the code and b) even converting the
function myself after deciding that you don't understand what I meant.  
Clearly this didn't work.  And maybe the problem is me, either because
my English is insufficient or I am a d***head.  Quite possible.

But even if I am the problem, you should be able to understand
somebody's review comments and act accordingly.  If not, I have a really
bad feeling about this.  And I hope someone else has more patience than
me, because this code still needs work.

Jörn

-- 
It is better to die of hunger having lived without grief and fear,
than to live with a troubled spirit amid abundance.
-- Epictetus
