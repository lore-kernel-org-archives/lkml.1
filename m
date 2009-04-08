Return-Path: <linux-kernel-owner+w=401wt.eu-S934487AbZDHRcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487AbZDHRcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZDHRcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:32:33 -0400
Received: from fmailhost01.isp.att.net ([207.115.11.51]:49897 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbZDHRcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:32:32 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49DCDF9E.8000605@lwfinger.net>
Date: Wed, 08 Apr 2009 12:32:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: alan-jenkins@tuffmail.co.uk
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
References: <49DC2DF5.3010603@lwfinger.net> <49DC31EA.8050208@linux.intel.com>	 <200904081631.09150.rusty@rustcorp.com.au>	 <49DCB976.4020200@lwfinger.net> <9b2b86520904081006m6e6b5276v834c3565b0f6f4c7@mail.gmail.com>
In-Reply-To: <9b2b86520904081006m6e6b5276v834c3565b0f6f4c7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> On 4/8/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
> Something is very wrong with request_module(), this is just the most
> obvious symptom.  It also seems to affect libusual (loading
> usb-storage) and FAT (loading NLS modules).
> 
> If I hotplug my wireless device, it then loads correctly.  So I'm
> guessing wireless modules e.g. encryption modules get loaded too
> asynchronously.   I.e. on boot, the  sub-modules are loaded too late.
> But when I hotplug the device, the modules are already loaded.
> 
> Same with FAT - it fails on first attempt to mount because of missing
> NLS module, then works on second mount,
> 
> I agree that commit looks like it should be a no-op though :-).
> I will try to confirm the OP's bisection by reverting the commit, acae0515.

I added printk's to the entry and exit from __request_module and obtained the
following:

module: __request_module entered for module snd-hda-codec-id:14f15051
module: loading module snd-hda-codec-id:14f15051 - call_usermodehelper returned 0
module: __request_module entered for module ecb(arc4)
module: loading module ecb(arc4) - call_usermodehelper returned 256
module: __request_module entered for module ecb
module: loading module ecb - call_usermodehelper returned 0
module: __request_module entered for module char-major-4-68
module: loading module char-major-4-68 - call_usermodehelper returned 256
module: __request_module entered for module char-major-4
module: loading module char-major-4 - call_usermodehelper returned 256
module: __request_module entered for module char-major-4-69
module: loading module char-major-4-69 - call_usermodehelper returned 256
module: __request_module entered for module char-major-4
module: loading module char-major-4 - call_usermodehelper returned 256
module: __request_module entered for module char-major-4-70
module: loading module char-major-4-70 - call_usermodehelper returned 256
module: __request_module entered for module char-major-4
module: loading module char-major-4 - call_usermodehelper returned 256
module: __request_module entered for module char-major-4-71
module: loading module char-major-4-71 - call_usermodehelper returned 256
module: __request_module entered for module char-major-4
module: loading module char-major-4 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256
module: __request_module entered for module net-pf-10
module: loading module net-pf-10 - call_usermodehelper returned 256

According to the description of the routine, it should return 0 on success and a
negative number for an error. Where do the values of "256" mean?

Larry
