Return-Path: <linux-kernel-owner+w=401wt.eu-S934309AbXHGOCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309AbXHGOCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761643AbXHGOBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:01:55 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:35564 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761182AbXHGOBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:01:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rvMwLU2BaAgyXXFWheze9i9PpTPsh5ZljwflICJGoS03X7ZJD0oLqDbTjp5YUz/ScBtL1R1mVcNbVT+FZVN6enEoV6QnH3PoiDJiDIJQv89i4DJK7uqzlGf7MB3nr03CEgD3GI6h6FWWLGMxHAUrhHzMxHg8u5hkjwdzgjLp1h8=
Message-ID: <46B87B4A.1020305@gmail.com>
Date: Tue, 07 Aug 2007 23:01:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: trenn@suse.de
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Michael Sedkowski <sedmich@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>,
       firmwarekit-discuss <firmwarekit-discuss@bughost.org>
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <1186411815.4355.7.camel@nx6310>	 <20070806150159.GC31615@khazad-dum.debian.net>	 <200708061732.03425.rjw@sisk.pl> <46B75459.9020204@gmail.com>	 <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com>	 <20070806234509.GC27640@khazad-dum.debian.net> <46B816FF.7060303@gmail.com>	 <20070807125104.GC30661@khazad-dum.debian.net> <46B86F21.4030805@gmail.com>	 <20070807131651.GE30661@khazad-dum.debian.net> <46B87457.4020704@gmail.com> <1186494328.8780.66.camel@queen.suse.de>
In-Reply-To: <1186494328.8780.66.camel@queen.suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
>>> I'd also suggest adding a FAIL to the Linux firmware toolkit to any DSDT
>>> doing this.  Who should we prod to add that check?
>> Dunno how the firmware toolkit works but this one can be pretty
>> difficult to test (if it were easy, we could test it in libata) as it
>> involves entering S5.  If it's possible, I'm all for it.  Also, it would
>> be nice if we can test the same thing for S3 and S4.
>>
>> Thomas, who should we ask things about the Linux firmware toolkit?  Thanks.
> 
> firmwarekit-discuss <firmwarekit-discuss@bughost.org> (added to CC list)
> see: http://linuxfirmwarekit.org/
> 
> But if I understand this problem right, this won't be easy.
> The ACPI tables are just parsed with system ("iasl ...") and syntactical
> errors/warnings are printed out.
> I also thought about a test, interpreting the DSDT and read out values
> of cpufreq tables and sanity check them. AFAIK the linuxfirmwarekit is
> not designed for that atm. You need to compile in most parts of the
> acpica code and parse and interpret DSDT/SSDT code yourself in the
> firmwarekit core or inside a plugin, then do a walk_namespace call or
> whatever to find the functions/parts you like to examine. This is a lot
> work and needs a proper design (providing an interface to plugins to let
> them easily check specific AML/ASL code).

Furthermore, we don't really know what we're looking for.  How can you
tell a given write to an ioport is issuing STANDBYNOW to an ATA disk or
trying to power the machine off?  Adding to the fun, many modern ATA
controller have more than one way to issue a command.  Maybe we can
match accesses inside regions specified by PCI BARs....  :-(

-- 
tejun
