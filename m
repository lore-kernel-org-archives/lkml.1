Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbXJWRYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbXJWRYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbXJWRX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:23:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60203 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbXJWRX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:23:57 -0400
Date: Tue, 23 Oct 2007 19:25:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Franck Bui-Huu <vagabon.xyz@gmail.com>, linux-arch@vger.kernel.org,
       linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Discardable strings for init and exit sections
Message-ID: <20071023172530.GA26345@uranus.ravnborg.org>
References: <Pine.LNX.4.64N.0710121711120.21684@blysk.ds.pg.gda.pl> <20071012171938.GB6476@stusta.de> <20071012175209.GA1110@linux-mips.org> <20071012181544.GC6476@stusta.de> <Pine.LNX.4.64N.0710231753250.8693@blysk.ds.pg.gda.pl> <20071023171201.GW30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023171201.GW30533@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> As long as the modpost warnings are just warnings they will often be 
> missed at compile time.

The plans for the modpost warnings are more or less:
- Let all __init, __cpuinit, __meminit etc use dedicated sections
no matter the actual configuration.
Use ifdeffery in the .lds files to place stuff in the correct final
section.
Teach modpost about the illegal dependencies.

When we then are back to almost warning free with allmodconfig for
the most important platfroms (read: or in reality the ones I have a
tool-chain for and which care to make allmodconfig buildable in mainline)
then modpost will generate errors instead of warnings to force people
to fix all the NEW errors they introuduce.

A variable will convert the errors to warnings for use in certain situations.

But I am not familiar enough with ELF format to extend the current checking
as suggested by people a few times. Maybe someone else can assist here.

Comments?

	Sam
