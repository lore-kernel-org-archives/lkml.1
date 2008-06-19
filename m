Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbYFSIVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbYFSIVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 04:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYFSIVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 04:21:23 -0400
Received: from mout.perfora.net ([74.208.4.197]:53040 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYFSIVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 04:21:21 -0400
Date: Thu, 19 Jun 2008 03:20:05 -0500 (CDT)
From: "R.L. Horn" <lists@eastcheap.org>
X-X-Sender: rlhorn@hani.compact.internal
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
In-Reply-To: <20080618185534.5f969f63@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LNX.1.00.0806190220340.1678@hani.compact.internal>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal> <alpine.LNX.1.00.0806162306400.10919@hani.compact.internal> <20080617095827.0f4f77de@lxorguk.ukuu.org.uk> <200806180215.45925.hpj@urpla.net>
 <20080618185534.5f969f63@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V01U2FsdGVkX19QoWDa8IQl7j9PxF0c0KAsYo92aeM/5gv0N5o
 i0ikcbPGtxwrv65QPfApAHO5s+iZcx50/P70Y0HhAHyfTl9wWP
 SE3Gvr85bhO4LRraV93RQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, Alan Cox wrote:

> I don't generally work via git so I don't offhand know the changeset id.
> I guess it could do. If its causing this many actual problem cases it
> might also want to go into stable.

I vote for nipping it in the bud ASAP.  There are currently eight stable 
kernel versions that exhibit this bug (which I believe is fairly serious, 
in breadth, if not depth), and it already has Adam Lackorzynski and me 
scratching our heads trying to figure out what, if anything, to do with 
minicom to accomodate it.

I would suggest one change to the 26-rc version.  Rather than bypassing 
tty_termios_encode_baud_rate() entirely in the B0 case, why not do 
something like:

     if (tty_termios_baud_rate(termios))
         tty_termios_encode_baud_rate(termios, baud, baud);
     else
         tty_termios_encode_baud_rate(termios, 0, 0);

to ensure that c_ispeed and c_ospeed are set (just for the sake of 
consistency)?
