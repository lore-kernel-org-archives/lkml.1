Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZCXVqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZCXVqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZCXVot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:44:49 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:47720 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755467AbZCXVos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:44:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1aqwIqrXa75htkJTEsN1cIUNTtNYEJtrYerSwwpqhABMHrd8R8i4TbGO0O6jwGpw/YKmfutsTfm4kN2ICc7UC1E07D9JbCRG2ffWQ/AvhbCwxXlk7mKliVMPes2WVY94Ros/Qk6ZYt2E62lKMWI/abxRxrs7MJtFS+t4jzEF7CE=  ;
X-YMail-OSG: RWV2rdwVM1n0kL.R0lUBwBMdywFaOcHtXtcGhrRei5T671Jt.JG3e6KaQQ7NX24yJ5b9ZEsRFZV9n_E5IMqPLO.AO6NPUqDoWKpDDXiQT5oMNBvNH9qvM6sZB7hNUF.ad4._cu.Yhw6wwEm9VmLaw2zoBNcVYKVXiT5oBHSlZ11DpLCea11I4DnV0OQ1XNry48sB4FWgT2QQ59p5BSe.0Mc_e2pMzg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/2] Add support for threaded interrupt handlers - V3
Date: Tue, 24 Mar 2009 14:44:44 -0700
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
References: <20090323172814.548471871@linutronix.de>
In-Reply-To: <20090323172814.548471871@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903241444.44644.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It still looks OK as a basic extension handling one
common model.

Once this is on track to merge (when?), I'd hope various
I2C and SPI device drivers would start to convert.  The
most common example might be handling RTC alarms from the
numerous I2C and SPI based RTCs. 

(The ones that don't need to manage an irq_chip across
that queued-message bus, and demux its IRQs.  PMICs are
a bit more likely to need to demux lots of IRQs.)


On Monday 23 March 2009, Thomas Gleixner wrote:
> I'm still looking into a clean solution for the threaded demultiplex
> handler case which was brought up by Dave to allow both the handling
> of the demultiplexed devices in the context of the demultiplexer
> interrupt thread and the wakeup of separate handler threads. But this
> is an orthogonal extension of the existing patch set and does not
> change the general design.

No comments on the patch I sent?

  http://marc.info/?l=linux-kernel&m=123734579014392&w=2

Or is that what you meant by "orthogonal"?  Admittedly that
patch sort of begs the question about which request_irq()
variant should be used for such demuxed IRQs; the "current"
assumption is that request_irq() suffices, but that could
be improved so the handle_threaded_irq() flow handler could
use the action->thread_fn not action->handler.

- Dave
