Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbYGSA7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbYGSA7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 20:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYGSA7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 20:59:25 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:10155 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYGSA7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 20:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BIyglm1PncSUq5C3uQlV6L89sZB+hTHzbr+U9vwPfbbqLE2wkued9GJQ1u41aXWV+e
         622vj7CAZQ8MKmHR6w/bhqvhHM9G1DUWaoA6vV+O0Xw4MblImN6VkIlHSmJ3A1SSBwhB
         fvtTnby8/frBHCLUidHjnRXgKw36Tgi76foKg=
Message-ID: <48813C5F.70007@gmail.com>
Date: Sat, 19 Jul 2008 09:59:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>	<200807170053.36661.rjw@sisk.pl>	<1216249292.3358.66.camel@localhost.localdomain>	<200807170109.30655.rjw@sisk.pl>	<48808EE0.2060603@gmail.com> <20080719004736.626ef169@mjolnir.drzeus.cx>
In-Reply-To: <20080719004736.626ef169@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> I just have one objection to your version, and that is that it cannot
> be used to nibble away at the sg list. The _next() call jumps an entire
> page, whereas you sometimes need to consume that page in two different
> sweeps. This could be handled by some external buffer that keeps the
> remainder of the page, but the point of these functions was to keep
> things simple for the callers.

Well, I don't know how often such usages would be necessary.  If it's a
very common ops, you can add a param to the next function but frankly I
think it's better to build a inside control structure for that.  There's
no need for external buffer, just an inner loop is sufficient.

-- 
tejun
