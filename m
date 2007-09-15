Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbXIOFqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbXIOFqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 01:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbXIOFqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 01:46:34 -0400
Received: from 20.5.221.87.dynamic.jazztel.es ([87.221.5.20]:54838 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751128AbXIOFqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 01:46:34 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 01:46:34 EDT
Date: Sat, 15 Sep 2007 07:39:13 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: On thread scheduling
Message-ID: <20070915053913.GM8592@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Heikki Orsila <shdl@zakalwe.fi>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070914224000.GI3400@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914224000.GI3400@zakalwe.fi>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, Sep 15, 2007 at 01:40:00AM +0300 Heikki Orsila ha dit:

> Consider a simple embedded system:
> 
> void interrupt_handler(void)
> {
> 	...
> }
> 
> int main(void)
> {
> 	...
> }
> 
> I would like to "emulate" this system with a workstation to make 
> development faster. I would create two threads, one executing the 
> main() function, and the other occasionally calling interrupt_handler(). 
> Before interrupt_handler() is called, the main() thread should be 
> stopped asynchronously.
> 
> I looked into pthreads documentation and found only pthread_kill(thread, 
> SIGTSTP) to do asynchronous stop, but then I also have to play terminal 
> tricks to avoid problems..
> 
> Is there are function to just disable scheduling of a single thread 
> without having other side-effects (such as terminal stuff)? Functions 
> like pthread_disable_scheduling(thread) and 
> pthread_enable_scheduling(thread) would be good for this..

i wonder if assigning a real time priority with
pthread_setschedparam() to the caller of your interrupt_handler()
function would solve your problem. this way the main() thread is never
scheduled when the interrupt_handler() thread is
runnable. interrupt_handler() should be as short as possible,
otherwise you risk starving of the rest of your systems processes.

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

        Representation of the world, like the world itself, is
        the work of men; they describe it from their own point
         of view, which they  confuse with the absolute truth
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
