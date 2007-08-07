Return-Path: <linux-kernel-owner+w=401wt.eu-S934518AbXHGNf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518AbXHGNf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762881AbXHGNfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:35:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:56328 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762873AbXHGNfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:35:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=T8DiByMODCLQLgvDNPYZysGAVQypl9cG98vvRqgZRk3L0uweWhLykFD2e49uIWfe1nsIgVAUyj2HU0L06ffk84PfENYtwF1VlnUwn5z9qExO6EY2Qj7gH/tUnUe8vJmhzmn9T2q1WkMUKA5yF3HrtHKsESOw42t8XCCERXCN7mg=
Message-ID: <46B87507.4090505@gmail.com>
Date: Tue, 07 Aug 2007 22:35:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: trenn@suse.de
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Michael Sedkowski <sedmich@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>	 <1186411815.4355.7.camel@nx6310>	 <20070806150159.GC31615@khazad-dum.debian.net>	 <200708061732.03425.rjw@sisk.pl> <46B75459.9020204@gmail.com>	 <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com>	 <20070806234509.GC27640@khazad-dum.debian.net> <46B816FF.7060303@gmail.com>	 <20070807125104.GC30661@khazad-dum.debian.net> <1186491879.8780.51.camel@queen.suse.de>
In-Reply-To: <1186491879.8780.51.camel@queen.suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
>>>> Any chances of changing things
>>>> so that we inspect/snoop all tasks sent to the device, and filter them
>>>> out, or react to them accordingly?
>>> No, we can't unless we snoop ACPI method execution and detect accesses
>>> to IO ports or iomem regions.  It's not going through any driver.  This
>>> is a gross mess.
>> I don't mean fixing the stuff clowns like Toshiba did.  The correct fix for
>> that is to blacklist the hell out of that crap and patch their DSDT into
>> something remotely sane.
>>
>> I do mean snooping the ACPI methods that *return* a taskset to send to the
>> driver, and we send that taskset ourselves in libata and libpata(?).
> 
> I haven't read the whole thread in every detail, but this sounds like a
> very intrusive, overdosed workaround.
> 
> Are the DSDT/SSDTs already lying around somewhere (collecting them in a
> bug assigned to ACPI component should be a good idea)?
> Could someone give me a pointer where this happens (best in code and
> DSDT).

The toshiba problem is already taken care of.  It's the issue that we
talked over beer.  Let me look up the bug number...  It's 7780.

  http://bugzilla.kernel.org/show_bug.cgi?id=7780

This was worked around by blacklisting the systems using dmi.

Thanks.

-- 
tejun
