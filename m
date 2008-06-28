Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYF1PeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYF1PeY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYF1PeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:34:16 -0400
Received: from ppsw-9.csi.cam.ac.uk ([131.111.8.139]:51299 "EHLO
	ppsw-9.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYF1PeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:34:15 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48665A09.9090705@cam.ac.uk>
Date: Sat, 28 Jun 2008 16:34:33 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Ben Nizette <bn@niasdigital.com>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>, hmh@hmh.eng.br,
       spi-devel-general@lists.sourceforge.net,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [lm-sensors] Accelerometer etc subsystem (Update on progress)
References: <4832A211.4040206@gmail.com>	 <20080520132817.03fb74ea@hyperion.delvare> <4863D97A.9090102@gmail.com>	 <1214537367.8462.157.camel@moss.renham>  <4864B6D6.3020509@cam.ac.uk> <1214642057.4265.7.camel@moss.renham>
In-Reply-To: <1214642057.4265.7.camel@moss.renham>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,
>>> union channel {
>>> 	char data[2];
>>> 	int16_t val;
>>> }
>> Good point, I'd forgotten you could do that with unions.
> 
> Cool, just watch endianness of course :-)
> 
That and the annoyance of alignment issues making that approach taking way more
space that you'd think.
>>> Incidentally, is there much that your ringbuffer can do which kfifo
>>> can't?  Apart from having a bunch of extra nice accessor-helpers sitting
>>> on the top.
>> Not sure, I'll look into it.
> 
> kfifo won't be a drop in replacement, it's just a very simple ring fifo.
> I suspect your higher level ring buffer accessors and allocators could
> live on top of it though.
Sure, but from my understanding of kfifo it takes a much more symmetric
approach to reading and writing with locking used to prevent them occuring
concurrently.  You obviously can use it without locking but I don't believe
that it provide any facility for coping with the nasty case, (buffer full
and hence during read attempts a certain amount of what is copied out may
have become invalid).  It maybe the case that, as you say suitable high level
functions on top of a kfifo would be a good way to proceed (afterall,  kfifo
is well tested etc), but I fear, given how little of kfifo's code would actually
be used it would be more likely to cause problems than not. 

It might be best to leave this decision until the exact requirements of the ring
buffer are actually known.

Jonathan
