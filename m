Return-Path: <linux-kernel-owner+w=401wt.eu-S934028AbXHPKxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028AbXHPKxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 06:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762540AbXHPKxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 06:53:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:59954 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762010AbXHPKxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 06:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jJKYp8Euj5b5D3Taw4QzNTsJEB0IxSt9ZEIBsVgiGRWyemJROYUcGDUQT1o2+WldfFRDF1WynXDpSlUgn+yNyFWmeg17e6/9+jtmlN069PMYWqUQaInhMqmmgCPm/Wc6CjjYMlVZ/hzDXbDB0eAHKY+v3YcbqroEVl3J6FV2UOo=
Message-ID: <46C42CAF.4040709@gmail.com>
Date: Thu, 16 Aug 2007 19:53:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andreas Radke <a.radke@arcor.de>
CC: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata drive loosing connection/resetting port
References: <20070813220241.3f4b8df5@workstation64.home>	<6bffcb0e0708131311k51238bb0l63eeb2fce53e3481@mail.gmail.com>	<46C180D8.9060005@gmail.com>	<20070814221928.243949b6@workstation64.home>	<46C29AE8.5070903@gmail.com> <20070815154846.28b6b462@workstation64.home>
In-Reply-To: <20070815154846.28b6b462@workstation64.home>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Radke wrote:
[on ahci]
> Aug 13 18:00:33 workstation64 ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400101 action 0x2 frozen
> Aug 13 18:00:33 workstation64 ata1.00: (irq_stat 0x08000000, interface fatal error)
> Aug 13 18:00:33 workstation64 ata1.00: cmd ca/00:08:a0:cb:07/00:00:00:00:00/e8 tag 0 cdb 0x0 data 4096 out
> Aug 13 18:00:33 workstation64 res 50/00:00:bf:32:07/00:00:00:00:00/e8 Emask 0x10 (ATA bus error)

Errors are very consistent.  Data transfer from the host to the drive
fails and SError indicates Handshake Error, Non-recovered transient data
integrity error and often Recovered Data integrity error.  For some
reason, your drive doesn't like what it's hearing from the controller
and replies with R_ERR.

[on ata_piix]
> Aug 14 23:06:01 workstation64 ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> Aug 14 23:06:01 workstation64 ata1.00: (BMDMA stat 0x26)
> Aug 14 23:06:01 workstation64 ata1.00: cmd ca/00:08:91:0d:45/00:00:00:00:00/e4 tag 0 cdb 0x0 data 4096 out
> Aug 14 23:06:01 workstation64 res 51/84:08:91:0d:45/00:00:00:00:00/e4 Emask 0x30 (host bus error)

As error reporting when using ata_piix is very limited.  It gets
reported as host bus error but I think it's basically the same problem.

I don't think this is driver issue.  I have the same controller and I've
never seen similar thing happening and I have plenty of drives and test
them often.  Error reports also point to transmission problems.  Your
drive just doesn't like what it's hearing.  Does 'smartctl -a /dev/sda'
tell anything special?

-- 
tejun
