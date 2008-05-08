Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYEHIfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYEHIfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYEHIfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:35:02 -0400
Received: from mail0.lsil.com ([147.145.40.20]:47448 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYEHIe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:34:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: Strange mptbase / mptscsih kernel messages
Date: Thu, 8 May 2008 16:33:58 +0800
Message-ID: <5AE055B67BB5764693E2900C7E3699BE0110FAEB@pamail.ad.lsil.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Strange mptbase / mptscsih kernel messages
Thread-Index: Aciw5WqIU/jHr8u6SLWevXHLgWgppQAAGjHA
From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>,
       <linux-scsi@vger.kernel.org>
X-OriginalArrivalTime: 08 May 2008 08:34:47.0736 (UTC) FILETIME=[5FDD3B80:01C8B0E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The meaning of 1 message is some fram transmit error encountered by
hardware and the I/O request is aborted by firmware because of the
error,
The second message indicates, some I/O got timed out and the SML tries
to abort the request and the firmware completes the I/O before aborting
that. Hence returns IO executed message and the driver completes the
abort as success.
Suspecting some bad hardware in the topology(cables?)
Thanks
sathya 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Andrew Morton
Sent: Thursday, May 08, 2008 1:57 PM
To: Bart Van Assche
Cc: LKML; Moore, Eric; linux-scsi@vger.kernel.org
Subject: Re: Strange mptbase / mptscsih kernel messages

On Thu, 8 May 2008 08:36:03 +0200 "Bart Van Assche"
<bart.vanassche@gmail.com> wrote:

> Hello,
> 
> I have made a setup with four servers, where each server is configured

> as follows:
> * Four Intel Xeon E5130 CPU cores.
> * 8 GB RAM.
> * SCSI storage controller: LSI Logic / Symbios Logic SAS1068E 
> PCI-Express Fusion-MPT SAS (rev 04),
> * 16 disks in a RAID6 setup (md).
> * Linux 2.6.24.6 kernel.
> 
> There is a lot of data being written to the RAID6 array: about 50 MB/s

> on each server. There are two kinds of messages that appear:
> 
> (1)
> [74887.117650] mptbase: ioc0: LogInfo(0x31120403): Originator={PL}, 
> Code={Abort}, SubCode(0x0403)
> 
> (2)
> [74917.081454] mptscsih: ioc0: attempting task abort! 
> (sc=ffff8100a18a7180) [74917.081461] sd 0:0:15:0: [sdp] CDB: 
> Write(10): 2a 00 1c fe 61 93 00 00 20 00 [74918.409801] mptbase: ioc0:

> LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, 
> SubCode(0x0000) [74918.639801] mptscsih: ioc0: task abort: SUCCESS 
> (sc=ffff8100a18a7180)
> 
> These messages appear a few times per day. Anyone any idea what the 
> meaning is of these messages and what the cause of these messages is ?
> 

(suitable cc's added)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
