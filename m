Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXAWGXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXAWGXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 01:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbXAWGXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 01:23:11 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:50635 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbXAWGXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 01:23:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hA/wGudxCZau0bDQSPzK4Pe5g9TmZrsA+jSfIaz4HtGCBZwHF/eMFNyYn3Bh0ZRABCukiG6afsaoXn9xcOTWvHFoLkJwpisknMTAPasAEL845llAB3YJFqOJMZ3LQP7ySL0oSj1qcQzd/M1wTmhG2yMlhxWYh/h/GQRIXAiycXs=
Message-ID: <45B5A9C7.5050700@gmail.com>
Date: Tue, 23 Jan 2007 15:23:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Soeren Sonnenburg <kernel@nn7.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SATA hotplug from the user side ?
References: <1168588629.5403.7.camel@localhost> <45A7BFB0.9090308@garzik.org> <1168639639.3707.6.camel@localhost> <45A83C22.6050409@gmail.com> <1168672966.3707.24.camel@localhost> <45AAE52B.2070705@gmail.com> <1169456682.2901.18.camel@localhost> <20070122210312.GD4516@khazad-dum.debian.net>
In-Reply-To: <20070122210312.GD4516@khazad-dum.debian.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> Does SATA electrical conector keying let the disk firmware unload
> heads before the user manages to pull it out enough to sever power?

I don't think so.

> If it does not, the drive will do an emergency head unload, which is
> not good and will likely reduce the drive's lifetime.

Probably.

> Using hdparm -Y before the unplug, or scsiadd -r (on a kernel that
> has Tejun's new patch to optionally issue an START_STOP_UNIT to the
> SCSI device enabled) is probably a good idea.  Unless it is a shared
> SATA port (I don't know if such a thing exists yet) and another box
> is talking to the disk, etc.

Agreed.  But it would be *much* better if all these can be taken care of
by hald and its minions.  Such that the user can just tell the system
that the hdd is going to be removed and all these dirty tricks are done
automagically.

-- 
tejun
