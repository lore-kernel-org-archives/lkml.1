Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYEKKbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYEKKbM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 06:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYEKKbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 06:31:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35548 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYEKKbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 06:31:00 -0400
Date: Sun, 11 May 2008 12:30:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Morten Welinder <mwelinder@gmail.com>
cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Deleting large files
In-Reply-To: <118833cc0805071614j49b10da6hfcbeb08cb3356afb@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0805111229520.19952@fbirervta.pbzchgretzou.qr>
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>  <Pine.LNX.4.61.0805071820010.25395@chaos.analogic.com> <118833cc0805071614j49b10da6hfcbeb08cb3356afb@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-08 01:14, Morten Welinder wrote:

>>  Suppose you had an N GB file that just filled up the disk. You now
>>  delete it, but get control back before it is really deleted. You
>>  now start to write a new file that will eventually just fill up
>>  the disk. [...]
>
>NFS does not do that -- in fact, I don't believe any file system does that
>unless you can guarantee at least that no other process or the kernel has
>that file open;

Iff a process still has the file open, your unlink will succeed immediately
anyway, and the real deallocation takes place when the last process runs
close(). Which shows an interesting fact too: not only unlink can block.
