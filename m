Return-Path: <linux-kernel-owner+w=401wt.eu-S933829AbZDAUOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829AbZDAUOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbZDAUO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:14:29 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57012 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbZDAUO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tRorurK948ail6tkXP/FpGs2E1qKvIxHmNiGpF1U22ueOqNnDRKSc2C+rmJfBv9O6E
         f/UgH/M10xKBE9+4dYOf6cOlkEfe91vIFy7y6ow5TUqE7b+t+4xSYl7FzvjQlq6Dewk5
         Y227WlnbB/peQYwMNpSihYqPOgKTr56NRYMbY=
MIME-Version: 1.0
In-Reply-To: <49D10256.8030307@vlnb.net>
References: <49D10256.8030307@vlnb.net>
Date: Wed, 1 Apr 2009 22:14:24 +0200
Message-ID: <e2e108260904011314h1e0cf5c5wcdf210eee24d40d8@mail.gmail.com>
Subject: Re: ISCSI-SCST performance (with also IET and STGT data)
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net,
       stgt@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 7:33 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
==================================================================
>
> I. SEQUENTIAL ACCESS OVER SINGLE LINE
>
> 1. # dd if=/dev/sdX of=/dev/null bs=512K count=2000
>
>                        ISCSI-SCST      IET             STGT
> NULLIO:                 106             105             103
> FILEIO/CFQ:             82              57              55
> FILEIO/deadline         69              69              67
> BLOCKIO/CFQ             81              28              -
> BLOCKIO/deadline        80              66              -

I have repeated some of these performance tests for iSCSI over IPoIB
(two DDR PCIe 1.0 ConnectX HCA's connected back to back). The results
for the buffered I/O test with a block size of 512K (initiator)
against a file of 1GB residing on a tmpfs filesystem on the target are
as follows:

write-test: iSCSI-SCST 243 MB/s; IET 192 MB/s.
read-test: iSCSI-SCST 291 MB/s; IET 223 MB/s.

And for a block size of 4 KB:

write-test: iSCSI-SCST 43 MB/s; IET 42 MB/s.
read-test: iSCSI-SCST 288 MB/s; IET 221 MB/s.

Or: depending on the test scenario, SCST transfers data between 2% and
30% faster via the iSCSI protocol over this network.

Something that is not relevant for this comparison, but interesting to
know: with the SRP implementation in SCST the maximal read throughput
is 1290 MB/s on the same setup.

Bart.
