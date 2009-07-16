Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZGPAG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZGPAG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 20:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZGPAG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 20:06:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34543 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756381AbZGPAGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 20:06:25 -0400
X-Sasl-enc: CvOTtpZQeKy8K2Qkk+RCbSGALwZb02f9837yei1OBKsq 1247702784
Date: Wed, 15 Jul 2009 21:06:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, ibm-acpi@hmh.eng.br,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.31-rc2: thinkpad boots with backlight low
Message-ID: <20090716000621.GA23073@khazad-dum.debian.net>
References: <20090714092513.GB2010@elf.ucw.cz>
 <20090715112204.GA16289@yamamaya.is-a-geek.org>
 <20090715143509.GC22098@khazad-dum.debian.net>
 <20090715223931.GA18924@yamamaya.is-a-geek.org>
 <20090715225936.GA30370@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715225936.GA30370@yamamaya.is-a-geek.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Tobias Diedrich wrote:
> Ok, after compiling it as a module and trying a few variations, it
> seems that on my X41 Tablet only brightness_mode=2 works, that is
> TPACPI_BRGHT_MODE_UCMS_STEP.

Ok...

> This is contrasted by thinkpad_acpi.c which states:
> |if (acpi_evalf(ec_handle, NULL, "HBRV", "qd"))
> |	/* T40-T43, R50-R52, R50e, R51e, X31-X41 */
> |	brightness_mode = TPACPI_BRGHT_MODE_ECNVRAM;
> |else
> |	/* all other IBM ThinkPads */
> |	brightness_mode = TPACPI_BRGHT_MODE_UCMS_STEP;
> 
> So TPACPI_BRGHT_MODE_ECNVRAM looks broken somehow?

Does the brightness change if you mess with /proc/acpi/ibm/brightness ? If
it doesn't, then it means your thinkpad doesn't use the EC to control
brightness.

And that will, of course, cause the driver to set the brightness in NVRAM to
zero (but it *should* do so for shutdown as well, not just machine-restart.
You may have uncovered two bugs, not just one), which will be honoured by
the BIOS on the next reboot/power up.

> I assume that the autodetection finds the HBRV acpi function and
> selects the former, resulting in a not working backlight control.

Yes.

Please send me by private mail the output of acpidump and dmidecode (so that
I will have them both in the same place).  I will blacklist your thinkpad to
force TPACPI_BRGHT_MODE_UCMS_STEP.

I wonder if other Intel GMA900 thinkpads also need this blacklisting,
though... this is the first report I got about HBRV not being good enough.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
