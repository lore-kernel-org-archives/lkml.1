Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZBPOUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZBPOUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 09:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbZBPOUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 09:20:04 -0500
Received: from main.gmane.org ([80.91.229.2]:39176 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbZBPOUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:20:01 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Renninger <trenn@suse.de>
Subject: Re: cpuinfo shows wrong MHz value
Date: Mon, 16 Feb 2009 14:19:50 +0000 (UTC)
Message-ID: <loom.20090216T141158-818@post.gmane.org>
References: <200902142217.51655.jplatte@naasa.net> <200902150800.59694.jplatte@naasa.net> <200902150811.36826.jplatte@naasa.net> <200902151741.30303.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 195.135.221.2 (Mozilla/5.0 (compatible; Konqueror/4.1; Linux) KHTML/4.1.3 (like Gecko) SUSE)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop <elendil <at> planet.nl> writes:

> 
> On Sunday 15 February 2009, Joerg Platte wrote:
> > Looks like p4_clockmod is responsible for these high values. After
> > removing it /proc/cpuinfo shows the correct values:
> 
> Can you check whether or not you were also using p4-clockmode with the 
> last kernel that did show correct values? The same grep command should 
> show this.
> 
> It would also help to know which kernel version was the last working one. 
> You mentioned 2.6.26, but with some uncertainty. Can you check for 2.6.26 
> and possibly for 2.6.27?
> 
> Note that p4-clockmode does not really help with power saving, but only 
> with thermal management (prevention of overheating).
Right and if, this should not be done via p4_clockmod, but via ACPI throttling
interface. In fact it could be that latest enhancements in the ACPI throttling
area could interfere with the p4_clockmode driver.

> Possibly the 
> speedstep or acpi-cpufreq modules will work better for you, but it can 
> also be they don't support your processor.
> That does not mean this issue should not be looked into of course.
IMO it's not worth looking into.
The p4_clockmode driver is broken by design (as ACPI can interfere with it).
I submitted a patch to remove it a while ago. The only reason it did not happen,
where some people who had broken HW (e.g. fan or whatever) the machine did not
shut down due to thermal overheating by using it.

There should be a message when this driver is loaded like:
"This driver is broken. Don't use it, don't complain."
Instead of:
  printk(KERN_WARNING PFX "Unknown p4-clockmod-capable CPU. "
           "Please send an e-mail to <cpufreq@vger.kernel.org>\n");

I will send a patch to the cpufreq list doing that, soon.

