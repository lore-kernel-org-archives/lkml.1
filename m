Return-Path: <linux-kernel-owner+w=401wt.eu-S1751656AbZHSLQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbZHSLQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 07:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZHSLQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 07:16:48 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57727 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZHSLQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 07:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C64YN9F1maML3vQKp5tt25/9HqilYrc2i8DbjbmNpjVZ/L8w8mTPLl7+upIAYDCnZB
         vEv5ssH21DeBgU9U2jfEg8KTANKFWFqs7Ahlos25oY+uqiCkxbhxii7ZruOvsoA3zL+Z
         LkVkrBPFenpmJdtaBtkqYCDuT/YOQ7uNp8WJk=
MIME-Version: 1.0
In-Reply-To: <20090819115301.563be6da@lxorguk.ukuu.org.uk>
References: <alpine.LFD.2.00.0908190022570.3361@localhost.localdomain>
	 <DE9C9034-D2CE-4D21-93D9-A10FE2580920@kernel.crashing.org>
	 <7099.1250674686@redhat.com>
	 <20090819115301.563be6da@lxorguk.ukuu.org.uk>
Date: Wed, 19 Aug 2009 13:16:48 +0200
Message-ID: <c384c5ea0908190416r4e0b5508x4765381888516484@mail.gmail.com>
Subject: Re: spin_is_locked() broken for uniprocessor?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Kernel List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 19, 2009 at 12:53 PM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 19 Aug 2009 10:38:06 +0100
>
> in drivers because there is driver code that uses spin_is_locked() in
> fairly sensible fashion when dealing with locking.
>
One use is to measure lock contention hits on a particular spin lock.


However I wonder if there are tracing capabilities to measure lock
contention on a particular lock?

Currently I have inserted code much like this to get a feeling on the
contention:

this_cpu = get_cpu();
put_cpu();
contention = spin_is_locked(&lock);
spin_lock*(&lock);
if (contention) {
  /* spin lock was contended, prev_cpu, this_cpu */
  /* no hard guarantee, as we had a possible race inbetween
is_locked() and lock(), but works for driver/irq spin lock */
}

/* critical section */

prev_cpu = this_cpu;
spin_unlock*(&lock);

Regards,
-- 
Leon
