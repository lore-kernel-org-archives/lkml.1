Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbXAXWBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbXAXWBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXAXWBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:01:53 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41041 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbXAXWBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:01:52 -0500
Message-ID: <45B7D750.1040501@drzeus.cx>
Date: Wed, 24 Jan 2007 23:01:52 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Petr Vandrovec <vandrove@vc.cvut.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx> <45B79C35.2090302@vc.cvut.cz>
In-Reply-To: <45B79C35.2090302@vc.cvut.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Vandrovec wrote:
>
> Hello,
>   create test scenario where first transmit of NCP request is lost by
> network, and before resend you kill this process.  So it stops
> resending, but local sequence count is already incremented.  Then when
> next process tries to access ncpfs, server will ignore its requests as
> it expects packet with sequence X, while packet with sequence X+1
> arrived.

Figured something along those lines, but I couldn't find any docs on the
protocol so I wasn't sure. You wouldn't happen to have any pointers to
such docs?

>
> And unfortunately it is not possible to simple not increment sequence
> number unless you get reply - when server receives two packets with
> same sequence number, it simple resends answer it gave to first
> request, without looking at request's body at all.  So in this case
> server would answer, but would gave you bogus answer.
>

This sounds promising though. In that case it wouldn't be necessary to
store the entire request, just the sequence number, right?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

