Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbYJHAai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbYJHAai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbYJHAaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:30:07 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:15780 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbYJHAaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=p2PuwqdOD84ruN/u19G3zVYlSLMaqkfv0MZPLS02Izg/IQQmWvZDMsWy6bZMqXoUJz
         BSYIRgd1ktGiMBb5nmrpCy7TYtBbms9UUS2MUE44KPAgikQLiRCML8f2B6aSLhpkQ4JY
         cMJJkpxvwsYCe7RIk5lLEjY6gLd5YnUrGrqy8=
Message-ID: <48EBFE9B.9070503@gmail.com>
Date: Wed, 08 Oct 2008 09:28:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Christian Mueller <Christian.Mueller@wdc.com>
CC: Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>
In-Reply-To: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing linux-ide and Mikael Pettersson)

Christian Mueller wrote:
> The messages I saw on the screen.

If the drive doesn't wake up and times out the smart command while
suspended (which probably is a bug in the firmware but it also can be
the controller's fault), then after the timeout, the driver should kick
in and reset the drive which will wake up the device and retry the
command.  It's not the prettiest picture but it's still gonna work.  In
Linda's case, it looks like the controller (sata_promise) went bonkers
on hardreset and requires power cycle to get back to working state.
That's why I asked Linda to try another controller.

Anyways, if you're seeing a similar problem, the driver or controller
probably can't do proper reset after timeout and I can't really help
with SAS driver on FreeBSD.  :-P

Mikael, the original thread is the following.

  http://article.gmane.org/gmane.linux.utilities.smartmontools/5842

Any ideas why hardreset doesn't work after SMART command timed out?

Thanks.

-- 
tejun
