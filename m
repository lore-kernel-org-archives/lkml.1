Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbYHDOgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbYHDOgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYHDOgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:36:24 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:1364 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbYHDOgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:36:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=r2bTZj6Jk3M4V8wSt4HHZiatX9n53d/iy3R2Kw9F8StQd5eXI7E/WcKyAEauHtDqSR
         mgn1hz46D8zDSwuo6ZdBGewRDed3ancf6BWueJOs44UfLLenvzV3195C/3cbBiBMDxAK
         +acYhAJk0Kuhl6pSXJOuLisgzNEX9nSS4tHSs=
Message-ID: <489713C0.6060909@gmail.com>
Date: Mon, 04 Aug 2008 23:35:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Gabor Gombas <gombasg@sztaki.hu>
CC: Elias Oltmanns <eo@nebensachen.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <87prp1kvyy.fsf@denkblock.local> <20080726062142.29070.10413.stgit@denkblock.local> <4892B8FE.1070400@gmail.com> <20080804142831.GW8749@boogie.lpds.sztaki.hu>
In-Reply-To: <20080804142831.GW8749@boogie.lpds.sztaki.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabor Gombas wrote:
> On Fri, Aug 01, 2008 at 04:19:26PM +0900, Tejun Heo wrote:
> 
>> However, SATA or not, there simply isn't a way to abort commands in ATA.
>>  Issuing random command while other commands are in progress simply is
>> state machine violation and there will be many interesting results
>> including complete system lockup (ATA controller dying while holding the
>> PCI bus).
> 
> A system lockup may be an acceptable compromise if that saves the
> hardware. Maybe the kernel should explicitely panic unless the
> controller/drive is known to be able to recover.

Such lockups usually would occur before the intervening command is
successfully issued.  HSM violation occurs when the driver asks the
controller to send another command while it's already processing another
command.  Heh... panicking on accelerometer would be fun tho.  We're
gonna get ourselves really flamewars on just about every linux news site.

-- 
tejun
