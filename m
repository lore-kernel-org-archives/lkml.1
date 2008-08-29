Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbYH2Kng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbYH2Kng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYH2Kn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:43:26 -0400
Received: from ag-out-0708.google.com ([72.14.246.240]:25940 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYH2KnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=r4wZsqUwOwz4VJQlby3kUrn1T7RBYh92n7yDnEwp9vqi7tsmeWdz7MDFukbWiu5HAu
         BOqhsKh5Z8Xdf5mz4WrTA/m0jkqHKNm4I0wArtKibKe70wq8JdmDehfZsIm0x8B+R37v
         76GlhiyhWgQ82g2gU6TowbLymL82z7wX7cAMw=
Message-ID: <48B7D286.7050104@gmail.com>
Date: Fri, 29 Aug 2008 12:42:14 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression: SATA disk double spin-off during hibernation on hp
 nx6325
References: <200808290002.55026.rjw@sisk.pl> <48B7C979.1000606@gmail.com> <200808291241.04183.rjw@sisk.pl>
In-Reply-To: <200808291241.04183.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Actaully, they do belong to it.  This is the part "fixing" the hibernation code
> path, in which the disk is also powered off unnecessarily.
> 
> Well, probably I should use SYSTEM_HIBERNATE_ENTER or something similar
> instead of SYSTEM_SUSPEND_DISK.
> 
> In short, the idea is to change system_state to something specific to the last
> phase of hibernation (after saving the image) and check that in
> ata_scsi_start_stop_xlat().  In fact that's completely analogous to what's done
> for SYSTEM_POWER_OFF in there.

Ah.. right, missed the added check for SUSPEND_DISK in libata-scsi.c.
Maybe it's a good idea to note it in the commit message later?

Thanks.

-- 
tejun
