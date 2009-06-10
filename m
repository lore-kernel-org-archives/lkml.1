Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbZFJJub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbZFJJub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZFJJuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:50:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33700 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754189AbZFJJuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:50:23 -0400
Date: Wed, 10 Jun 2009 10:51:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luke-Jr" <luke@dashjr.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pty tcdrain() bug in 2.6.27 to 2.6.30/current
Message-ID: <20090610105118.564a53de@lxorguk.ukuu.org.uk>
In-Reply-To: <200906092338.42368.luke@dashjr.org>
References: <200906092338.42368.luke@dashjr.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> manner. The following test case reproduces the bug, and hangs only on affected 
> kernels. Examination of 2.6.26 and 2.6.27 suggests the ioctl used by tcdrain 
> underwent a rewrite for 2.6.27, and thus fixing this bug is beyond my 
> capabilities at this time.

I don't see a bug at this point

> 	slavefd = open(ptsname(masterfd), O_NOCTTY | O_RDWR);
> 	assert(slavefd != -1);
> 	
> 	assert(sizeof(test) == write(slavefd, test, sizeof(test)));

Queue data to the other end...

> 	assert(!tcdrain(slavefd));

Wait for it to be read, but with nothing reading it.

So it waits as it should.


What is the bug here ?

Alan
