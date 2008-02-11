Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbYBKXY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbYBKXY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYBKXYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:24:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbYBKXYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:24:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Priit Laes <plaes@plaes.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: REGRESSION: x86 vDSO: remove vdso-syms.o
In-Reply-To: Ingo Molnar's message of  Tuesday, 12 February 2008 00:16:35 +0100 <20080211231635.GA27673@elte.hu>
References: <1202769045.10829.12.camel@localhost>
	<20080211225332.2AE2E270191@magilla.localdomain>
	<20080211231635.GA27673@elte.hu>
X-Shopping-List: (1) Obsolescent beagles
   (2) Aberrant rubber
   (3) Educated removal expectorants
   (4) Poisonous awkward chowder
   (5) Chivalrous ghost-melt bums
Message-Id: <20080211232345.A472B270191@magilla.localdomain>
Date: Mon, 11 Feb 2008 15:23:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> if that file is empty, it might be the effect of a Ctrl-C. I sometimes 
> get that on .o files, if i Ctrl-C a highly parallel make -j at the wrong 
> moment. (is this expected behavior? It's been like this for a long 
> time.)

It is the known situation with the compiler since the dawn of time, yes.
It just writes the file directly, so if it dies in the middle, there's a
file with a fresh date.  For things like this done in makefile commands
with >, it has forever been canonical for the anal to use:

	... > $@.new
	mv -f $@.new $@

which avoids the problem.  The kernel makefiles are entirely haphazard
about places that do this or don't.  It uglifies the commands, but avoids
the problem of freshly-dated but wrong/empty files from botched make runs.
I did not do this in cmd_vdsosym (though I did in cmd_vdso32sym, go figure).


Thanks,
Roland
