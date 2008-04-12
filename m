Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYDLTU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYDLTU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYDLTUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:20:20 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:40247 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbYDLTUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:20:19 -0400
Date: Sat, 12 Apr 2008 16:19:14 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Audio skipping with 2.6.24.4 and 2.6.25-rc9
Message-ID: <20080412191914.GA6573@localhost.ift.unesp.br>
Mail-Followup-To: Frederik Himpe <fhimpe@telenet.be>,
	linux-kernel@vger.kernel.org
References: <pan.2008.04.12.16.13.01@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2008.04.12.16.13.01@telenet.be>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 12.Apr'08 at 16:13:01 +0000, Frederik Himpe wrote:
> I'm experiencing a lot of problems with audio skipping on my system. I am 
> using Rhythmbox as an audio player and have Compiz active. Whenever I 
> maximise or restore a maximised real transparent gnome-terminal, audio 
> skips. Compared to other normal applications, restoring the transparent 
> console is also slow (it takes a few seconds before the window appears).
> 
> I ran cfs-debug-info-clear.sh, and the reproduced the problem 3 times by 
> restoring and minimising a gnome-terminal window. After that I ran cfs-
> debug-info.sh, and I uploaded the information here: 
> http://artipc10.vub.ac.be/cfs-debug-info-2008.04.12-18.00.20.gz
> 
> This problem happens with both 2.6.24.4 as with 2.6.25-rc9 (the debugging 
> information is from the latter version).

I once learned ( http://lkml.org/lkml/2008/2/29/179 )
that the CFS would have something to do with the latencies I was
observing in my system if se.wait_max was bigger than 40 msecs.
It would be an "anomaly" in CFS.

But in the log you uploaded you have only two se.wait_max greater than
40 msecs

[mafra@localhost:~]$ grep se.wait_max cfs-debug-info-2008.04.12-18.00.20 |awk '{ {if ($3 > 40.000000) print $3} }'
44.153039
50.841370

As these numbers are only a bit greater than 40, I guess your problem is not
related to the CFS scheduler.

Can you try latencytop? ( www.latencytop.org )

Bye,
Carlos
