Return-Path: <linux-kernel-owner+w=401wt.eu-S935274AbXHHOav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935274AbXHHOav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764922AbXHHOaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:30:30 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:59876 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762377AbXHHOa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=i0iR+YdpokWcbuK1wj6ss4MNZGexJw1J/A8Qr492dsCnxaNkRls0JTGvvSaIoaxXqcXLtNCPYEgtKyA/B90m8JcZ5Bd9ZveRIvvp9fo9PlQOSn52vKdhKEL5T8E0rGvy+NB8+QM4fx/++ioNTKTqSvTSY494b6c/gbm0PXx0xbc=
Message-ID: <46B9D37A.4070403@gmail.com>
Date: Wed, 08 Aug 2007 23:30:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Michael Sedkowski <sedmich@gmail.com>, trenn@suse.de,
       Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no>	 <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no>	 <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no>	 <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no>	 <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no>	 <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca>	 <46B8140E.3000509@gmail.com>  <1186497925.8780.78.camel@queen.suse.de> <1186514618.5622.9.camel@nx6310> <46B9307D.3000105@gmail.com> <46B9CE79.5030307@rtr.ca> <46B9CFB3.6020402@gmail.com> <46B9D219.6030509@rtr.ca>
In-Reply-To: <46B9D219.6030509@rtr.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Heh.. I haven't instrumented it yet, but I did discover a bit more about
> it:
> 
> The Power-Off_Retract_Count incrmenents *only* when there's data in the
> on-drive write-cache.  So if I haven't written anything significantly large
> before suspending, then it often does NOT increment the retract counter.
> 
> But if I copy a couple of multi-MB files around and then suspend (to RAM),
> the retract count gets incremented.
> 
> So I've now just stuck "hdparm -F /dev/sda" into my suspend script,
> and that cures the problem completely for me.  "-F" does a FLUSH_CACHE,
> and requires a recent copy of hdparm.
> 
> Perhaps libata should also do a FLUSH_CACHE before any STANDBYNOW command,
> prior to entering STR, which is what my script is currently now doing..
> 
> I'll instrument libata and see what the current sequence is.

Hmmmm.. libata should issue FLUSH CACHE on STR too.  sd_suspend() and
sd_shutdown() are pretty similar after all.

-- 
tejun
