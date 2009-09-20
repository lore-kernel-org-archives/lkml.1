Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbZITGHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbZITGHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 02:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZITGHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 02:07:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:49423 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbZITGHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 02:07:20 -0400
Date: Sun, 20 Sep 2009 08:07:28 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Poor desktop responsiveness with background I/O-operations
Message-ID: <20090920080728.73bfe2a1@infradead.org>
In-Reply-To: <4AB59CBB.8090907@datenparkplatz.de>
References: <4AB59CBB.8090907@datenparkplatz.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 05:08:43 +0200
Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de> wrote:
> 
> Observation:
> - The system becomes _really_ slow as described above; unusable for
>   any multimedia tasks.
> 
> - Using an encrypted (dm-crypt/LUKS) /home (e.g. on mobile computers)
>   compounds the issue to a painful extent.
> 
> 
> 
> Possible culprits (I'm guessing) are the Linux I/O- or CPU scheduler.

this has nothing to do with the cpu scheduler.... 
can you try the following two things?

echo 4096 > /sys/block/sda/queue/nr_requests
for i in `pidof kjournald` ; do ionice -c1 -p $i ; done

to see if they help?

they tweak the IO scheduler... I assume you're using CFQ.
