Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351AbXBYQhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbXBYQhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 11:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbXBYQhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 11:37:16 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:6593 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbXBYQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 11:37:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ey7bYmYok7GdGry8UNSfdTco/vsmOQHj8Z2Xi8Wt7x/dIVt/4EH4MYJvwxemucRDN/lQMEC4XCGHPr6l8zb5uJuhgTRupmBuyUsYo5/ETF6ijrG265EDuI/6meM8L0bLMmZHWF75LadaZIcG3pJ69j8XTMupCO86BRtoAJmFskg=
Message-ID: <45E1BB34.6010608@gmail.com>
Date: Mon, 26 Feb 2007 01:37:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>,
       Alan <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-git10 (and -git13): BUG at drivers/pci/pci.c:817 during
 resume from disk
References: <200702150016.24865.rjw@sisk.pl> <200702151223.44846.rjw@sisk.pl> <200702171100.39114.rjw@sisk.pl> <45DA6E6D.5030700@gmail.com> <20070224230259.GU12392@stusta.de> <45E1107A.2040708@gmail.com> <20070225163200.GZ12392@stusta.de>
In-Reply-To: <20070225163200.GZ12392@stusta.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Feb 25, 2007 at 01:28:42PM +0900, Tejun Heo wrote:
>> Hello, Adrian.
>>
>> Adrian Bunk wrote:
>>> On Tue, Feb 20, 2007 at 12:43:41PM +0900, Tejun Heo wrote:
>>>> Rafael J. Wysocki wrote:
>>>>> Update:
>>>>>
>>>>> I get the same BUG with 2.6.20-git13 100% of the time during the resume.
>>>>> The system seems to be fully functional nonetheless.
>>>> Known bug, will be fixed soon.
>>> Is this a variation of
>>>
>>> Subject    : HP nx6325: usb mouse stops working after resume from ram
>>> References : http://lkml.org/lkml/2007/2/21/413
>>> Submitter  : Arkadiusz Miskiewicz <arekm@maven.pl>
>>> Caused-By  : Konstantin Karasyov <konstantin.a.karasyov@intel.com>
>>>              commit 0a6139027f3986162233adc17285151e78b39cac
>>> Status     : unknown
>>>
>>> or one of the other ACPI problems in 2.6.21-rc1?
>> No, it's not related to ACPI.  It's caused by devres changes and fixed
>> in libata-dev tree.
> 
> I'm currently a bit lost with all the ATA/ACPI/suspend regression 
> reports...
> 
> Which patch fixes this regression?

What I was talking about was the following one.  It's a libata bug
discovered by devres sanity check and unrelated to ACPI.

Author: Tejun Heo <htejun@gmail.com>  2007-02-20 18:14:48
Committer: Jeff Garzik <jeff@garzik.org>  2007-02-21 18:58:18
Parent: 5e5c74a5e11d1e2a99d03132cc6c4455016db6c2 (sata_nv: delay on switching between NCQ and non-NCQ commands)
Child:  6d1245bf294e9ea65b3717be9fa0338bfb6ff6c9 (libata: separate out ata_ncq_enabled())
Branches: upstream-fixes, upstream, ALL
Follows: v2.6.21-rc1
Precedes: 

    libata: disable pdev on all suspend events
    
    libata used disable pdev only on PM_EVENT_SUSPEND while re-enable pdev
    unconditionally.  This was okay before ref-counted pdev enable update
    but it now makes the pdev pinned after swsusp cycle (enabled twice but
    disabled only once) and devres sanity check whines about it.
    
    Fix it by unconditionally disabling pdev on all suspend events.
    
    Signed-off-by: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

-- 
tejun
