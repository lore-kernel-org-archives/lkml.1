Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbYCJJGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbYCJJGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 05:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYCJJGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 05:06:23 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:45945 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750836AbYCJJGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 05:06:22 -0400
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2008 10:13:41 +0100
MIME-Version: 1.0
Subject: Re: block layer / FS question: x86_32bit with LBD, 20 TB RAID volume => funny issues
Message-ID: <47D509D5.13560.C993B08E@localhost>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.32@12660
X-Seznam-User: frantisek.rysanek@post.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 7 Mar 2008 at 10:30, Andi Kleen wrote:
> [...snip...]
> > BTW your problems mostly sound like driver issues. Some drivers 
> > (and some controller firmwares) have problems with large block numbers
> > 
> thanks for that hint, I'll investigate that too.
> 
> The HBA is a Qlogic QLA-2460. Based on some past experience with 
> other brands of FC HBA's, I tend to swear on Qlogic as the reference 
> implementation of FC hardware.
> 
And indeed it was the firmware.
ftp://ftp.qlogic.com/outgoing/linux/firmware/

Until now, I've been using version v4.00.27, which is the last 
numbered version in that FTP directory.

Upon closer inspection, I picked the file called 
ql2400_fw.bin_mid
with a timestamp from 12th February 2008.
This one turns out to be v4.03.01 and it SOLVES THE PROBLEM :-)

It seems to work with qla2xxx v8.01.07-k7 (2.6.22.6) and
v8.02.00-k5 (2.6.24.2).

My testbed server has passed some 5 loops of dd over the weekend.

Thanks for your help :-)

I'm installing a 64bit Fedora to give XFS another try...

Frank Rysanek

