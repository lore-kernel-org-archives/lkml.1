Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbXLITxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbXLITxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 14:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXLITxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 14:53:04 -0500
Received: from mx1.riseup.net ([204.13.164.18]:43048 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbXLITxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:53:03 -0500
Date: Sun, 9 Dec 2007 20:53:01 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Charlie Brady <charlieb@budge.apana.org.au>
Cc: linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPP synchronous tty: convert dead_sem to completion
Message-ID: <20071209195301.GF15658@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Charlie Brady <charlieb@budge.apana.org.au>,
	linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071208150954.GA8467@traven> <Pine.LNX.4.64.0712091203490.976@e-smith.charlieb.ott.istop.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712091203490.976@e-smith.charlieb.ott.istop.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, Dec 09, 2007 at 12:04:48PM -0500 Charlie Brady ha dit:

>
> On Sat, 8 Dec 2007, Matthias Kaehlcke wrote:
>
>> PPP synchronous tty channel driver: convert the semaphore dead_sem to
>> a completion
>>
>> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
>
> Excuse my ignorance please, but why is this a good idea? Should we not 
> record the reason for changes?

Semaphores can be used to signal completion of a job, but aren't the
optimal way to do so. According to LDD3 semaphores are optimized for
the 'available' case and performance suffers when using them as
completion. 

It is also clearer to use each synchronization mechanism according to
its purpose, i.e. semaphores for protection of critical sections and
completions for signalling that a job is done.

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

              You can't separate peace from freedom because no
               one can be at peace unless he has his freedom
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
