Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbXEGIR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbXEGIR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 04:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbXEGIR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 04:17:26 -0400
Received: from host1.audiocodes.com ([212.25.125.1]:46224 "EHLO
	aclmsg.corp.audiocodes.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754139AbXEGIR0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 04:17:26 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: select-like implementation for kernel sockets
Date: Mon, 7 May 2007 11:04:06 +0300
Message-ID: <EF8DFB1B64FF0A43AB00555B8E2717B104973BF7@aclmsg.corp.audiocodes.com>
In-Reply-To: <416aa1ad0705062357i5a76684ao1d45ef235a6cd20f@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: select-like implementation for kernel sockets
Thread-Index: AceQdSK1YzK16eQoQryBH1nz5m3wDAACKmrg
From: "Eitan Richardson" <Eitan.Richardson@audiocodes.com>
To: "kalash nainwal" <kalash.nainwal@gmail.com>,
       "Robert Hancock" <hancockr@shaw.ca>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the tip.
I understand sk_data_ready is a callback that is called when there is
data ready in the socket.

Is it safe to override it?
Do you have an example?

Thanks,
Eitan.

-----Original Message-----
From: kalash nainwal [mailto:kalash.nainwal@gmail.com] 
Sent: Monday, May 07, 2007 9:57 AM
To: Robert Hancock
Cc: Eitan Richardson; linux-kernel
Subject: Re: select-like implementation for kernel sockets
Importance: Low

On 5/6/07, Robert Hancock <hancockr@shaw.ca> wrote:
> eitanr@audiocodes.com wrote:
> > Hi,
> >
> > I'm using kernel sockets to Tx and Rx UDP packets between my
hardware
> > device (DSP) to the external network (this is part of a VoIP
> > implementation). The motivation for using kernel sockets rather than
> > user-space sockets is to avoid the copying of data between kernel
and
> > user spaces.
>
> I think we are zero-copy in many cases for UDP these days, so this
> doesn't necessarily buy you anything..
>
> >
> > I have no problems on the Tx side (I simply call sock_sendmsg on one
> > of the sockets), but for the Rx side I want to listen-in on multiple
> > sockets in blocking mode (I don't want to use polling).
> >
> > Is there a way to listen-in on multiple kernel sockets from one
kernel
> > thread? In the user space I would have used select(), but I am not
> > familiar with a similar solution for the kernel space.
> >

implementing (sock->)sk_data_ready() might serve your purpose?

> > Thanks,
> > Eitan.
> >
> > Eitan Richardson
> > AudioCodes Ltd.
> >
>
> --
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>
> -
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
