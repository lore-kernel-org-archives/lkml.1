Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZDNAru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZDNAru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZDNArk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:47:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:10463 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZDNArj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:47:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=c0fMX58uAwxYcvUC3yh95YqY4qIo2j7nya1zsdmzA3/Fa3d++kB5XEijx44Tmh6ipO
         6SrCap4ejrDCnBX+DWIB1RPuChp6VYJkdx2iw6PFOdbWq+Thr2I1DONmg0z9OpxbOMue
         5atQjp83xgIPlqUsEPhJGKRP15UYp2U0BFFrc=
Message-ID: <49E3DD23.1080806@gmail.com>
Date: Mon, 13 Apr 2009 18:47:31 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Andreas <andreas@maxxle.de>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB: Buffer I/O error on device dm-0, logical block XYZ
References: <1239573569.5997.21.camel@legolas> <1239609328.5997.25.camel@legolas>
In-Reply-To: <1239609328.5997.25.camel@legolas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(ccing linux-usb)

Andreas wrote:
> More information from dmesg: 
> 
> [  223.882858] EXT3 FS on dm-0, internal journal
> [  223.882917] EXT3-fs: recovery complete.
> [  223.924925] EXT3-fs: mounted filesystem with ordered data mode.
> [  967.909484] kjournald starting.  Commit interval 5 seconds
> [  967.915929] EXT3 FS on dm-0, internal journal
> [  967.917466] EXT3-fs: mounted filesystem with ordered data mode.
> [ 1740.369047] ehci_hcd 0000:00:10.3: fatal error
> [ 1740.370244] ehci_hcd 0000:00:10.3: HC died; cleaning up
> [ 1740.370489] usb 1-3: USB disconnect, address 2

This is the real killer here, everything else is just collateral damage. 
  Looks like your USB host controller indicated a fatal host system 
error, apparently because of an error on the PCI bus, which seems rather 
bizarre. Some kind of hardware problem?

> [ 1740.394603] sd 2:0:0:0: [sdb] Unhandled error code
> [ 1740.394636] sd 2:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT
> driverbyte=DRIVER_OK,SUGGEST_OK
> [ 1740.394671] end_request: I/O error, dev sdb, sector 614444231
> [ 1740.394867] Buffer I/O error on device dm-0, logical block 76805264
> [ 1740.394943] lost page write due to I/O error on dm-0
> [ 1740.394984] Buffer I/O error on device dm-0, logical block 76805265
> [ 1740.395053] lost page write due to I/O error on dm-0
> [ 1740.395149] sd 2:0:0:0: [sdb] Unhandled error code
> [ 1740.395164] sd 2:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT
> driverbyte=DRIVER_OK,SUGGEST_OK
> [ 1740.395191] end_request: I/O error, dev sdb, sector 614444247
> [ 1740.395519] Buffer I/O error on device dm-0, logical block 76805266
> [ 1740.395607] lost page write due to I/O error on dm-0
