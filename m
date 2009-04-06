Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbZDFTCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbZDFTCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZDFTBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:01:52 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45306 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZDFTBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gE4H3/+JWy5WZJFG6BeYXYmENDWgSZuCdKF6Uy1mw1X0sPriJ7KhztCk7ITtb/QT7C
         x27Dh/kr99kpKz/WsMuys8LJvfEftenma2a78ohWfi6+4PRUZyVUfYGKVBW66v6snNSY
         rvaAGduo+IqVgvfwoPXS0pzBDqXshDW2HQM8k=
MIME-Version: 1.0
In-Reply-To: <49D9D9A0.40106@wpkg.org>
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org>
	 <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com>
	 <49D9D9A0.40106@wpkg.org>
Date: Mon, 6 Apr 2009 21:01:47 +0200
Message-ID: <e2e108260904061201y1e73d1chca088e6f20b1ddf6@mail.gmail.com>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between 
	different SCSI targets (SCST, STGT, IET, LIO)
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 12:29 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> The target is running Debian Lenny 64bit userspace on an Intel Celeron
> 2.93GHz CPU, 2 GB RAM.
>
> Initiator is running Debian Etch 64 bit userspace, open-iscsi 2.0-869, Intel
> Xeon 3050/2.13GHz, 8 GB RAM.
>
>
> Each test was repeated 6 times, "sync" was made and caches were dropped on
> both sides before each test was started.
>
> dd parameters were like below, so 6.6 GB of data was read each time:
>
> dd if=/dev/sdag of=/dev/null bs=64k count=100000
>
>
> Data was read from two block devices:
> - /dev/md0, which is RAID-1 on two ST31500341AS 1.5 TB drives
> - encrypted dm-crypt device which is on top of /dev/md0
>
> Encrypted device was created with the following additional options passed to
> cryptsetup
> (it provides the most performance on systems where CPU is a bottleneck, but
> with decreased
> security when compared to default options):
>
> -c aes-ecb-plain -s 128
>
>
> Generally, CPU on the target was a bottleneck, so I also tested the load on
> target.
>
>
> md0, crypt columns - averages from dd
> us, sy, id, wa - averages from vmstat
>
>
> 1. Disk speeds on the target
>
> Raw performance: 102.17 MB/s
> Raw performance (encrypted):  50.21 MB/s
>
>
> 2. Read-ahead on the initiator: 256 (default); md0, crypt - MB/s
>
>                          md0   us  sy  id  wa  | crypt   us  sy  id  wa
>  STGT                      50.63   4% 45% 18% 33% | 32.52    3% 62% 16% 19%
> SCST (debug + no patches) 43.75   0% 26% 30% 44% | 42.05    0% 84%  1% 15%
> SCST (fullperf + patches) 45.18   0% 25% 33% 42% | 44.12    0% 81%  2% 17%

Hello Tomasz,

How is it possible that for this test the read performance through
STGT (50.63 MB/s) was higher than the read performance on the target
(50.21 MB/s) ? Are you sure that all read buffers were flushed before
this test was started ?

Bart.
