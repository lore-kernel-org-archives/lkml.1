Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbYHRPBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbYHRPBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYHRPBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:01:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52984 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYHRPBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:01:12 -0400
In-Reply-To: <20080814111210.GI6995@ucw.cz>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFFC89CC8B.668BE16F-ON852574A9.00517F82-852574A9.00527E25@us.ibm.com>
From: Kenneth Goldman <kgoldman@us.ibm.com>
Date: Mon, 18 Aug 2008 11:01:04 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/18/2008 11:01:10
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> wrote on 08/14/2008 07:12:10 AM:

> Only 2 TPMs I've seen were on pluggable modules... which was fortunate
> because they slowed down boot by 5+ minutes, and broke it completely
> in other cases. Nickname 'kurvitko' (aka useless trash that breaks
> stuff). They are currently lying under my table, disconnected.
>
> (OTOH they were not on PCI, but on some low-count pin header).

1 - The pluggable modules use a standard LPC bus header.  In my>
experience, all the TPM vendors supply them in low quantities for
evaluation and test, but no one expects them to be used in
production because of the security issues.

2 - I'd be interested to know whether the slowdown was in
the BIOS, in the OS boot, or on bringup of an application?
Was this Linux or some other OS?

Both the TCG and the platform vendors are very sensitive to
the BIOS part of the boot time.  For example, the TPM self test
is broken into a fast part for features that are required
before boot and a slower part that can be done later. There
are recommendations to break up hashing to remove the TPM
from the critical path.

Even then, the slowest TPM operation is keypair creation,
on the order of 1-5 seconds, which should not be required
during boot.  I wonder if the problem was actually a code
bug or unsupported operation causing timeouts?

It would be great if you could debug a bit and report your
findings to us.

