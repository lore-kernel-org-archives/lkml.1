Return-Path: <linux-kernel-owner+w=401wt.eu-S934429AbXHGNc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934429AbXHGNc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbXHGNcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:32:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:52116 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759393AbXHGNcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=M44UJkzwDdzB2Cfx+EqPZJ+/bEWpbDf0atEnWLoxGaTptnP8DB1fEB3IHiE05kQPCU829gOSFORCJhcLLHgtt8WcCXC9GqB1SEYVJyeKRq+KTBmwR5ZpMjUsAzBZ9b9gXaNMM6E9dlN673qNyUidn9KDhdUgctZmKZ9FSEQJrKA=
Message-ID: <46B87457.4020704@gmail.com>
Date: Tue, 07 Aug 2007 22:32:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Michael Sedkowski <sedmich@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <1186411815.4355.7.camel@nx6310> <20070806150159.GC31615@khazad-dum.debian.net> <200708061732.03425.rjw@sisk.pl> <46B75459.9020204@gmail.com> <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com> <20070806234509.GC27640@khazad-dum.debian.net> <46B816FF.7060303@gmail.com> <20070807125104.GC30661@khazad-dum.debian.net> <46B86F21.4030805@gmail.com> <20070807131651.GE30661@khazad-dum.debian.net>
In-Reply-To: <20070807131651.GE30661@khazad-dum.debian.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Tue, 07 Aug 2007, Tejun Heo wrote:
>> Henrique de Moraes Holschuh wrote:
>>>> approximately translates into "if you have too many boatmen on a ship,
>>>> it goes to mountain".  We also have a bunch of Toshiba laptops which
>>> Yeah, that's a problem.  But we can avoid it if we start snooping what ACPI
>>> is asking us to deliver to the disks, which IMO is an extremely good idea
>>> anyway.
>> If it were done that way (by asking OS driver to deliver commands TFs),
>> I wouldn't have any problem at all.  The spin down command is issued
>> from deep down in the acpi power off method - entering S5 directly
>> issues ATA commands bypassing the whole OS except for the ACPI
>> interpreter.  It's just like the toshiba suspend crap and there's no
>> standard way to tell whether the acpi power off method is gonna do it or
>> not.  We'll just have to blacklist it.
> 
> Urk. I see.
> 
> I'd also suggest adding a FAIL to the Linux firmware toolkit to any DSDT
> doing this.  Who should we prod to add that check?

Dunno how the firmware toolkit works but this one can be pretty
difficult to test (if it were easy, we could test it in libata) as it
involves entering S5.  If it's possible, I'm all for it.  Also, it would
be nice if we can test the same thing for S3 and S4.

Thomas, who should we ask things about the Linux firmware toolkit?  Thanks.

-- 
tejun
