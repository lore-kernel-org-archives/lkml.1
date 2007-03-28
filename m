Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbXC1Ohe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbXC1Ohe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXC1Ohe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:37:34 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:50692 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752100AbXC1Ohd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:37:33 -0400
X-VirusChecked: Checked
X-Env-Sender: Scott_Kilau@digi.com
X-Msg-Ref: server-18.tower-29.messagelabs.com!1175092627!4978311!7
X-StarScan-Version: 5.5.10.7.1; banners=-,-,-
X-Originating-IP: [66.77.174.21]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: Re: question on tty open and close
Date: Wed, 28 Mar 2007 09:37:19 -0500
Message-ID: <335DD0B75189FB428E5C32680089FB9F012DCE77@mtk-sms-mail01.digi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: question on tty open and close
Thread-Index: AcdxRpXQeb2Uou94S4mGx3CkeifErQ==
From: "Kilau, Scott" <Scott_Kilau@digi.com>
To: <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Mar 2007 14:37:20.0375 (UTC) FILETIME=[97524870:01C77146]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > So we have a file that's closed although open() never
succeeded?
> > > > 
> > > > That's correct! It's been a pain in my butt for years.
> > > 
> > > How did you deal with that proctological issue?
> > 
> > Just make sure the close() handles the situation properly. It makes
> > reference counting...  fun.
> > 
> > The serial driver has always handled it like this.
> 
> I'm also not aware of any reason other than history, which means if
> someone cares to double check the other drivers there really shouldn't
be
> an obstacle to "fixing" this behaviour.
> 
> Unless anyone knows different ?

Hi Alan!

>From our (Digi's) drivers history, I believe you tried "fixing" it back
in the Red Hat 7.1 days. =)

Sadly, our drivers still carry this legacy fix around.

    o Red Hat 7.1 -- Kernel Compatibility Issues
         Some 2.4 kernel-based distributions (Red Hat 7.1 included) have
a patch
         applied to them which modifies the behavior of Linux when an
open of
         a serial port is canceled (for instance, if an application is
waiting
         for the carrier signal and a user hits CTRL-C to kill the
application)
        
         With this behavior change, the device driver is unable to
cleanup its
         internal data structures and the sane functioning of the driver
is
         compromised.  The classic symptom of this problem is that the
command
         "lsmod", which (among other things) will return a count of the
         applications using the device driver, will return a non-zero
value
         even if all applications associated with the serial ports
         are killed.   
            
         Unfortunately, it is impossible (from within the device driver)
to
         determine which behavior is implemented in the running kernel.
         However, Digi now provides a workaround to allow customers with
this
         problem to change the Digi behavior to be compatible with these
         "patched" kernels.


I know backwards compatibility in the kernel isn't a concern at all,
which has been made abundantly clear, (ie, stable_api_nonsense.txt),
but this will impact *all* out of tree serial drivers.

Just wanted to toss this out there.
Scott Kilau
