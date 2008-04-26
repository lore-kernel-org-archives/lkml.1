Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbYDZSD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbYDZSD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758288AbYDZSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:03:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41641 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbYDZSDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:03:15 -0400
Date: Sat, 26 Apr 2008 20:03:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Nick Andrew <nick@nick-andrew.net>
cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Sam Ravnborg <sam@ravnborg.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kbuild@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in
 header file
In-Reply-To: <20080426142235.GB7051@tull.net>
Message-ID: <alpine.LNX.1.10.0804262001400.20150@fbirervta.pbzchgretzou.qr>
References: <20080426134554.GA20727@damson.getinternet.no> <48133537.7040800@cs.helsinki.fi> <19f34abd0804260717le1773aapec49cdb6f68e296f@mail.gmail.com> <20080426142235.GB7051@tull.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-04-26 16:22, Nick Andrew wrote:
>On Sat, Apr 26, 2008 at 04:17:15PM +0200, Vegard Nossum wrote:
>> I didn't want to get into the lands of parsing options since we would
>> need to handle gcc options and skip arguments to those, etc.
>
>?
>
>use Getopt::Std qw(getopts);
>use vars qw($opt_g);
>getopts('g');
>[...]
>if ($opt_g) {
>	graph();
>}

Try this, at least it is known to handle pass_through, which
is _just what we want_ for handling unknown options:

	use Getopt::Long;
	&Getopt::Long::Configure(qw(bundling pass_through));
	&GetOptions("g" => \$opt_g, "I" => \@include_paths);
