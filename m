Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbZAYLJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbZAYLJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 06:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZAYLIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 06:08:54 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:50536 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbZAYLIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 06:08:53 -0500
Date: Sun, 25 Jan 2009 12:08:39 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Another libata error related to OCZ SSD
Message-ID: <20090125110839.GA4691@ics.muni.cz>
References: <20090111174159.GC4250@ics.muni.cz> <200901192239.25071.rjw@sisk.pl> <497BB9BB.4040608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <497BB9BB.4040608@kernel.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 25 Jan 2009 12:08:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 10:00:43AM +0900, Tejun Heo wrote:
> 
> Does the following command make any difference?
> 
>  echo 0 > /sys/class/scsi_disk/h:c:i:l/manage_start_stop
> 
> The h:c:i:l part needs to be adjusted to point to the OCZ disk.  lscsi
> will show which value to use.

Well, the real problem seems to be in touching link power management policy
(it did not happen with ata_piix driver thus the driver seemed to be ok)

If I touch power management with theses commands:
echo max_performance > /sys/class/scsi_host/host0/link_power_management_policy
echo medium_power > /sys/class/scsi_host/host0/link_power_management_policy

the suspend fails.

I always restore max_performance policy before the suspend.

-- 
Luká¹ Hejtmánek
