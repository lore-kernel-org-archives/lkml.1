Return-Path: <linux-kernel-owner+w=401wt.eu-S1031457AbXDZTNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031457AbXDZTNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031390AbXDZTNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:13:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:40748 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031457AbXDZTNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OSNbSpP8C08J2tKNPGuJ4VztqZl+GSvuVPt8gKLBUqHJ4jbl8bXB+6L5syrHp4gL4FMsqu/O8P1Sv9wsWsIVuGHZSww608hQxSSO9jFhQqQ5K8oZ2Dq3EbAPit6V3msqYoJmBlo4UP2BRyYTAkcSz6b/XE+uafENVtrnLEo4k0Y=
Message-ID: <a44ae5cd0704261213o37944b46u5dbdd231fc6a2490@mail.gmail.com>
Date: Thu, 26 Apr 2007 12:13:00 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc7-mm2 -- gnome-power-manager always shows the power as coming from AC
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One possible issue is that /proc/acpi/power_resource/ is an empty directory.
Otherwise, the ACPI information seems to be fine:

# cat /proc/acpi/ac_adapter/ACAD/state
state:                   on-line
# cat /proc/acpi/ac_adapter/ACAD/state
state:                   off-line

# cat /proc/acpi/battery/BAT0/state
present:                 yes
capacity state:          ok
charging state:          discharging
present rate:            0 mA
remaining capacity:      7072 mAh
present voltage:         12487 mV

When I unplug the power cable, /proc/acpi/battery/BAT0/state (present
rate) shows that current flowing from the battery.

# cat /proc/acpi/button/lid/LID0/state
state:      closed
# cat /proc/acpi/button/lid/LID0/state
state:      open
