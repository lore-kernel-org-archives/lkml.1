Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbXLLPMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbXLLPMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXLLPMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:12:30 -0500
Received: from bender.weihenstephan.org ([62.245.246.226]:40764 "EHLO
	bender.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLLPM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:12:29 -0500
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [RFT] Port 0x80 I/O speed
Date: Wed, 12 Dec 2007 16:12:25 +0100
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org
References: <475F1DC6.5090403@keyaccess.nl> <200712120959.59952.juergen127@kreuzholzen.de> <475FF094.8000709@keyaccess.nl>
In-Reply-To: <475FF094.8000709@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712121612.25974.juergen127@kreuzholzen.de>
X-CTCH-RefID: str=0001.0A0B0203.475FF963.026D,ss=1,fgs=0
X-cff-SpamScore: 0(/)
X-cff-SpamReport: ----- ----- Message is unknown to the spam scanner.
X-cff-LastScanner: pcre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2007 15:30, Rene Herman wrote:
> On 12-12-07 09:59, Juergen Beisert wrote:
> > $ for i in `seq 5`; do ./port80; sleep 1; done
> > cycles: out 5260, in 2372
> > cycles: out 5260, in 2384
> > cycles: out 5260, in 2323
> > cycles: out 5270, in 2382
> > cycles: out 5259, in 2323
> >
> > $ cat /proc/cpuinfo
> > processor       : 0
> > vendor_id       : GenuineIntel
> > cpu family      : 6
> > model           : 7
> > model name      : Pentium III (Katmai)
> > stepping        : 3
> > cpu MHz         : 501.208
>
> This one's really wrong. This would be 10 microsecs. I suppose the
> machine/bus was heavily loaded or something?

Ups, your are right:

$ cat /proc/acpi/processor/CPU0/throttling
state count:             2
active state:            T1
states:
    T0:                  00%
   *T1:                  50%

With T0 it get:

$ for i in `seq 5`; do ./port80; sleep 1; done
cycles: out 684, in 280
cycles: out 684, in 280
cycles: out 684, in 280
cycles: out 684, in 280
cycles: out 684, in 280

Juergen
