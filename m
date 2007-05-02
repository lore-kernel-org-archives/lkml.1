Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbXEBKOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbXEBKOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbXEBKOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:14:55 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:45048 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991AbXEBKOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:14:54 -0400
Date: Wed, 2 May 2007 12:14:53 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Dylan Taft" <d13f00l@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange UDP Issue on 2.6.20.8 - broadcasts not being received
 if socket bound to local ip
Message-Id: <20070502121453.6d1fbc67.dada1@cosmosbay.com>
In-Reply-To: <47ed01bd0705020255x3a05cabbo955b4e980771b92@mail.gmail.com>
References: <47ed01bd0705020255x3a05cabbo955b4e980771b92@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 05:55:28 -0400
"Dylan Taft" <d13f00l@gmail.com> wrote:

> I've been pulling my hair out for the past several hours trying to
> debug a program in wine.  I'm currently on kernel 2.6.20.8.  The
> problem was that I was not getting any broadcasts to 255.255.255.255
> on a UDP socket bound to 192.168.0.8 with SO_BROADCAST enabled.
> 
> I was fiddling around a bit, broadcasts come in fine if the socket is
> bound to INADDR_ANY( 0.0.0.0), but if it's bound to 192.168.0.8
> nothing comes in.  I did a packet sniff, and indeed packets were being
> sent out to 255.255.255.255 via another machine on the network.  I
> wrote a quick test program that would bind a socket to the lan ip and
> wait for incoming data.  I tested it on a windows machine and linux.
> The windows machine could pick up packets fine, my linux machine could
> not.   Is this proper behavior?  It's fudging up several games and
> things in the wine project.
> 
> Does anyone else experience this?  Thanks!

It seems you are expecting too much of SO_BROADCAST option.

http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_10.html

SO_BROADCAST :

Non-zero requests permission to transmit broadcast datagrams (SOCK_DGRAM sockets only).

Note this only handles the transmission of packets, not receiving them.

