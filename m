Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbYGULEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbYGULEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbYGULD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:03:56 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:30534 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbYGULDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GWhOjqNM4Q8ki2p3K2HXy40/8lb8QZvuAwee7NEsF4/lWFObHdSTzneM9oE0m3dywh
         80dUVuY2VGWNCSLEb8h7yemEt1jutdkVh5bPQp9IEvH3I4qDNeM1JLa0O1v3Kz/JM3tR
         7CRHPNh/FMdlXWdepuKME20zjEHWBZf05U7Cg=
Message-ID: <19f34abd0807210403n1bca348fn83773b55a08b7993@mail.gmail.com>
Date: Mon, 21 Jul 2008 13:03:50 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       cl@linux-foundation.org, davem@davemloft.net
In-Reply-To: <20080721105051.GA5830@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717214222.GA29449@elte.hu>
	 <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI>
	 <20080718091146.GQ6875@elte.hu> <20080721094110.GA16029@elte.hu>
	 <84144f020807210252k68d5cf65i8c7ae3c11cecc046@mail.gmail.com>
	 <20080721100627.GA5953@2ka.mipt.ru> <20080721105051.GA5830@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 12:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
> the problem is, most of the crashes dont come with any usable dump. This
> is a laptop so netconsole is the only reliable route out - and if
> something in networking crashes chances are that it hoses netconsole
> before it can get anything out.
>
> Another thing is that i'm activating netconsole on this box via a kernel
> boot line and from within a bzImage (to get it activated as early as
> possible) - maybe that's a tad too early for certain initialization
> sequences?
>
> I could try run tests with netconsole deactivated, if you think that's a
> worthwile line of probing this problem. (although that would make me do
> blind tests in essence - having kernel log output is really essential.)

How about posting your custom patches for public review? :-D

(There was recently an odd case of kzalloc() succeeding even though it
was called before the slab caches were initialized -- and it only
generated a warning about irqs-on happening too early. I just mean to
say that it _can_ happen. On another machine, it crashed
spectacularly. I guess you're not enabling the netconsole before slab
allocator is up?)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
