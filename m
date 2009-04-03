Return-Path: <linux-kernel-owner+w=401wt.eu-S933598AbZDCRJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbZDCRJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbZDCRIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:08:46 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53681 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbZDCRIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:08:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hfTVGdGNSXPxa+kh6fbBw/W53yNzAxI17eR4rJqBn1+lk0HmCyyXFNkrp3Upc8VJbi
         +AQDlMC+Sf0k4bWtT2CCV7f6WyrZzuEvhA8JLRO6vOW/TFBOcHMhBV4eDnBH57mlWOkx
         7uiv7C6NM5SY/3HgzVHMQRFKC/KdnuMMbwYgY=
MIME-Version: 1.0
In-Reply-To: <49D4F2E1.7000507@vlnb.net>
References: <49D10256.8030307@vlnb.net>
	 <e2e108260904011314h1e0cf5c5wcdf210eee24d40d8@mail.gmail.com>
	 <49D4F2E1.7000507@vlnb.net>
Date: Fri, 3 Apr 2009 19:08:41 +0200
Message-ID: <e2e108260904031008u434e6d06rc7d657a087e64fbc@mail.gmail.com>
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT data)
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 7:16 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> Bart Van Assche, on 04/02/2009 12:14 AM wrote:
>> I have repeated some of these performance tests for iSCSI over IPoIB
>> (two DDR PCIe 1.0 ConnectX HCA's connected back to back). The results
>> for the buffered I/O test with a block size of 512K (initiator)
>> against a file of 1GB residing on a tmpfs filesystem on the target are
>> as follows:
>>
>> write-test: iSCSI-SCST 243 MB/s; IET 192 MB/s.
>> read-test: iSCSI-SCST 291 MB/s; IET 223 MB/s.
>>
>> And for a block size of 4 KB:
>>
>> write-test: iSCSI-SCST 43 MB/s; IET 42 MB/s.
>> read-test: iSCSI-SCST 288 MB/s; IET 221 MB/s.
>
> Do you have any thoughts why writes are so bad? It shouldn't be so..

It's not impossible that with the 4 KB write test I hit the limits of
the initiator system (Intel E6750 CPU, 2.66 GHz, two cores). Some
statistics I gathered during the 4 KB write test:
Target: CPU load 0.5, 16500 mlx4-comp-0 interrupts per second, same
number of interrupts processed by each core (8250/s).
Initiator: CPU load 1.0, 32850 mlx4-comp-0 interrupts per second, all
interrupts occurred on the same core.

Bart.
