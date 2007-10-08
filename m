Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbXJHNBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbXJHNBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 09:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbXJHNBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 09:01:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:21159 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbXJHNBl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 09:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DnUKtV727/SLVu6L6zaAP8x73/1x3X70aK9wITSVjix+j/HHee4e40NKQGufa1b51ERkrQQIl5+gnl7+keXPMYIm3YBSD0ynGYmXn2N5TE99xux3omonwzXHNoNkyLRa+s3LTlPVAjXtiQmVduBDnu52FXYBL7hXwyhVeywhCug=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Malte =?iso-8859-15?q?Schr=F6der?= <maltesch@gmx.de>
Subject: Re: Strange network related data corruption
Date: Mon, 8 Oct 2007 14:01:32 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <20071007184741.3b1951c1@highlander.home.lan>
In-Reply-To: <20071007184741.3b1951c1@highlander.home.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710081401.32375.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 October 2007 17:47, Malte Schröder wrote:
> Hello,
> I am encountering some strange data corruption when transferring
> data from one of my PCs that I use as a file-server.
> 
> on the server:
> FILE=<large file>; | cut -d" " -f1 | nc -lp5000 -q0; while nc
> -lp5000 -q0 < $FILE; do : ; done

$ cat z
FILE=z; | cut -d" " -f1 | nc -lp5000 -q0; while nc -lp5000 -q0 < $FILE; do : ; done

$ sh z
z: line 1: syntax error near unexpected token `|'
z: line 1: `FILE=z; | cut -d" " -f1 | nc -lp5000 -q0; while nc -lp5000 -q0 < $FILE; do : ; done'

> on the client:
> H=<server>; SUM=$(nc -q0 $H 5000);sleep 1s; while nc -q0 $H 5000 |
> sha1sum | (grep -v $SUM || echo -n .); do sleep 1s ;done
> 
> (output looks somewhat like this:
> ..............6dd5fb1ce29d270acdfbb02d00921bf75d141773  -
> ...
> )
> 
> I would expect the sha1sum to be the same in every pass (assuming the
> source file does not change). But every few passes (with no apparent
> pattern) there is a different sum returned. I first noticed this when
> transferring large files (backups) with with SMB and NFS(v3 and v4) but
> to rule that out I tried netcat in the way noted above.

Does it happen over loopback?

tcpdump / tcpflow may help seeing whether there is some corruption
(TCP checksumming should have catched that, but worth looking into).
Basically, you wait for "wrong" checksum to appear, then
you stop script and look into tcpdump/tcpflow logs.
--
vda
