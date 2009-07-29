Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbZG2GXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbZG2GXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZG2GXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:23:05 -0400
Received: from leia.mcbone.net ([194.97.104.42]:43815 "EHLO leia.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbZG2GXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:23:04 -0400
Subject: Re: futexes: Still infinite loop in get_futex_key() in 2.6.31-rc4
From: Jens Rosenboom <jens@mcbone.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sonny Rao <sonnyrao@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1248701812.6987.1637.camel@twins>
References: <1248681637.7279.12.camel@fnki-nb00130>
	 <1248694266.6987.1594.camel@twins>  <1248697004.7279.31.camel@fnki-nb00130>
	 <1248697409.6987.1617.camel@twins>  <1248698755.7279.47.camel@fnki-nb00130>
	 <1248701812.6987.1637.camel@twins>
Content-Type: multipart/mixed; boundary="=-DhK6LyDHAURgMire+2tt"
Date: Wed, 29 Jul 2009 08:22:48 +0200
Message-Id: <1248848568.6757.13.camel@fnki-nb00130>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DhK6LyDHAURgMire+2tt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2009-07-27 at 15:36 +0200, Peter Zijlstra wrote:
[...]
> Bugger.. how easy it is to reproduce?

Okay, my colleague found the right combination of scripts, take the two
attached, run them both a couple of times in parallel for some hours,
and get a stuck ps. This happens both on an old 2.6.29.1 I happened to
still have on one machine as with 2.6.31-rc4. Both of them dual-core
Opterons as the original one. If you want further tracebacks or other
information, let me know.

--=-DhK6LyDHAURgMire+2tt
Content-Disposition: attachment; filename="null.pl"
Content-Type: application/x-perl; name="null.pl"
Content-Transfer-Encoding: 7bit

#!/usr/bin/perl -w
use strict;

my $a = 'a';
while (1) {
 $0 = "null_".$a++;
}

--=-DhK6LyDHAURgMire+2tt
Content-Disposition: attachment; filename="pees.pl"
Content-Type: application/x-perl; name="pees.pl"
Content-Transfer-Encoding: 7bit

#!/usr/bin/perl -w
use strict;

while (1) {
 my @a = grep (/ SOMETHING: /, `ps ax 2>/dev/null`);
}

--=-DhK6LyDHAURgMire+2tt--

