Return-Path: <linux-kernel-owner+w=401wt.eu-S966841AbXEHMln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966841AbXEHMln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934367AbXEHMlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:41:42 -0400
Received: from tango.0pointer.de ([85.214.72.216]:48859 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535AbXEHMll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:41:41 -0400
Date: Tue, 8 May 2007 14:41:39 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [PATCH] DMI-based module autoloading
Message-ID: <20070508124139.GA18511@tango.0pointer.de>
References: <20070508005429.GA19182@tango.0pointer.de> <20070508012736.GA24856@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508012736.GA24856@suse.de>
Organization: .phi.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
X-Disclaimer-1: Diese Nachricht wurde mit einer elektronischen 
X-Disclaimer-2: Datenverarbeitungsanlage erstellt und bedarf daher 
X-Disclaimer-3: keiner Unterschrift.
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07.05.07 18:27, Greg KH (gregkh@suse.de) wrote:

Hi!

> On Tue, May 08, 2007 at 02:54:29AM +0200, Lennart Poettering wrote:
> > To take advantage of DMI based module autoloading, a driver should
> > export one or more MODULE_ALIAS fields similar to these:
> > 
> > MODULE_ALIAS("dmi:*:svnMICRO-STARINT'LCO.,LTD:pnMS-1013:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
> > MODULE_ALIAS("dmi:*:svnMicro-StarInternational:pnMS-1058:pvr0581:rvnMSI:rnMS-1058:*:ct10:*");
> > MODULE_ALIAS("dmi:*:svnMicro-StarInternational:pnMS-1412:*:rvnMSI:rnMS-1412:*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
> > MODULE_ALIAS("dmi:*:svnNOTEBOOK:pnSAM2000:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
> 
> Is there any way to automatically generate these aliases (like we do for
> PCI and USB), in a way that is easier for the developer, instead of
> having to figure out how to create such a "wierd" string like these by
> hand?

Automatically? You mean by having some kind of macro that generates
the string from its parameters or some kind of structure and than use
"file2alias" to generate the alias lines automatically?

I am not sure if that is a good idea, because people really need to
clean up their strings manually before putting them into
MODULE_ALIAS. DMI data blocks usually contain a lot of rubbish. People should
really think twice when writing down those lines.

It's not that difficult to write these strings by hand, they are not
that weird. Also, on systems with this patch applied all you need to
do is run "cat /sys/class/dmi/id/modalias" to get the proper
MODULE_ALIAS string for your respective machine. Then, just replace
all rubbish with "*" and you are done.

If required I can hack up a simple script that generates the data from
dmidecode.
 
> > These lines are specific to my msi-laptop.c driver. They are basically
> > just a concatenation of a few carefully selected DMI fields with all
> > potentially bad characters stripped.
> 
> What is a "bad character" here?

All characters <= 32 and >= 127, and ':'. The latter we use for
separating the DMI fields in the modalias strings, hence we don't want
the DMI data to use that character.

Lennart

-- 
Lennart Poettering; lennart [at] poettering [dot] net
ICQ# 11060553; GPG 0x1A015CC4; http://0pointer.net/lennart/
