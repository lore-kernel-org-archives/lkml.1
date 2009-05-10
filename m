Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZEJXYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZEJXYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 19:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZEJXY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 19:24:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:40732 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZEJXY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 19:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=S4W2DPNCAUfznN8vdDaivgqFXSUjpPMxzvFFjaU5ZBLx8hMw+wxQIYt4V0CsUBi3X9
         JzCIJAojXqgn8pjzSb+jdaHYPmoFuQMaz/gIm4EZ4vhEVV3coC4Yh6wmX7cNK7QleL3D
         CaEiomEgnoM7vip0J5TI6bhAV+QiH5rQ5n6w0=
Message-ID: <4A076275.5000307@gmail.com>
Date: Mon, 11 May 2009 08:25:41 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [mmotm 2009-04-30] ata: failed to IDENTIFY
References: <20090510114759.GA7577@localhost>
In-Reply-To: <20090510114759.GA7577@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The warning message seems suspicious.  I'll look into it.

Wu Fengguang wrote:
...
> [ 5986.864611] ata1.00: qc timeout (cmd 0xec)
> [ 5987.153668] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [ 5987.159861] ata1.00: revalidation failed (errno=-5)
> [ 5987.164854] ata1: hard resetting link
> [ 5987.500647] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [ 5997.508508] ata1.00: qc timeout (cmd 0xec)
> [ 5997.512720] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [ 5997.518913] ata1.00: revalidation failed (errno=-5)
> [ 5997.523893] ata1: limiting SATA link speed to 1.5 Gbps
> [ 5997.529149] ata1: hard resetting link
> [ 5997.860516] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [ 6027.868126] ata1.00: qc timeout (cmd 0xec)
> [ 6027.872339] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [ 6027.878530] ata1.00: revalidation failed (errno=-5)
> [ 6027.883507] ata1.00: disabled
> [ 6027.886603] ata1: hard resetting link
> [ 6028.220134] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [ 6028.226450] ata1: EH complete
> [ 6028.229748] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6028.237583] Restarting system.
> [ 6028.240745] machine restart

But the above failures seem to indicate that IRQ delivery went out the
window during shutdown before ATA shuts down properly.  I don't think
this is something caused by libata proper.  Would it possible for you
to bisect the problem?

Thanks.

-- 
tejun
