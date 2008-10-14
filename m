Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYJNIvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYJNIvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYJNIu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:50:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:41988 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbYJNIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:50:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:newsgroups:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding:from
         :sender;
        b=YJxU1HEEGQIAkFqUNn7lsOytiuwsmONzbknSLgBExmH4c6AwD36+Xhn4bYz5IIp+hk
         Rj4O8uSj/I2fwi+yq64PZoSzesIHdEV2OoRHi4FpYXu1YCoSlfEFFcP+hlGnKQ2hep/z
         61ZMnZjzFpLWG05l0WyiKh+52KWTYIn9JRFGo=
Message-ID: <48F45D52.2010407@tuffmail.co.uk>
Date: Tue, 14 Oct 2008 09:50:26 +0100
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
Newsgroups: gmane.linux.acpi.devel,gmane.linux.kernel
To: Pavel Machek <pavel@suse.cz>
CC: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Robert Goldner <robert@au-79.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>, linux-stable@vger.kernel.org
Subject: Re: Patch needed for ASUS EEEPC 701 2.6.27 (perhaps a regession)
References: <48F0BD2D.8000001@tuffmail.co.uk> <20081013203648.GA3260@ucw.cz>
In-Reply-To: <20081013203648.GA3260@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2008-10-11 15:50:21, Alan Jenkins wrote:
>> Robert Goldner wrote:
>>
>>> Hi,
>>>
>>> I am a happy user of an asus eeepc 701 with an self-made kernel 2.6.27.
>>> Its working quite good, but there is one patch needed to avoid problems
>>> related to ACPI and Hotkeys.
>>> After using a few hotkeys there comes a message in syslog like:
>>> ACPI: EC: GPE storm detected, disabling EC GPE
>>> and no hotkey event is recognized any more. This is quite bad on a nettop.
>> Hi, I reported the original bug.  It is a regression, though the issue
>> has been present for a few kernel versions now.
>>
>> I recommend that you avoid reproducing the problem.  I now have to add
>> "noapic" to the boot options on my EeePC, otherwise it randomly hangs /
>> reboots when I press hotkeys - I think it  damaged the hardware.
> 
> I guess your hw went bad for some other reason. Restore original
> system and if it is still broken, RMA?
> 

It could be a coincidence.  But it's suspicious enough to advise caution.  We know what the bug is, and we have a very nice workaround queued up now.  There's no reason to test any more of these specific systems to destruction :).

I did try re-installing off the vendor DVD and it was still broken.  I fear I bought it from the wrong place to get sympathetic _frontline_ support / warrantee.  I'm not interested in RMA back to Asus - too much work and downtime for a cheap system, when I have an easy workaround.  I haven't noticed any problems with "noapic".


The symptoms strongly suggest overflow in an event buffer or counter maintained by the Embedded Controller.  So the EC firmware may have a bug, of the sort that results in "unspecified behaviour".  A bug in a special purpose (read: not subject to wide testing) subsystem which has direct connections to things like frequency and voltage control.

Hopefully I'm wrong, and I don't really know what I'm talking about here.

Regards
Alan
