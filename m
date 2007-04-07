Return-Path: <linux-kernel-owner+w=401wt.eu-S965291AbXDGEX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291AbXDGEX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 00:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965301AbXDGEX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 00:23:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:19833 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965291AbXDGEX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 00:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SMem17P9bCmLYIJsv14/MfkU+0967KMYc2kcqDhxn/uMtnGepPDYGAiaaXNgVq/p0YDks7STQxq6t0R7wQWHYKVsk8NdArhTcdR8iCSdSGXv9SEUPThnQl1oBko6ty8YR8JDYdg2dOs5BBpRZz91nqHaxZJxOqlFD+ylPJm91U0=
Message-ID: <7e0bae390704062123i2dfaf030icd5a710677bc989a@mail.gmail.com>
Date: Sat, 7 Apr 2007 11:23:54 +0700
From: "Andika Triwidada" <andika@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CPU offline but power consumption increased?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://andika-lives-here.blogspot.com/2007/03/eksperimen-cpu-hotplug-dan-konsumsi.html

* initial setup:
root@hokage:~# cpufreq-set -d 1.666g
root@hokage:~# cpufreq-set -u 1.666g
root@hokage:~# cpufreq-set -g userspace
root@hokage:~# cpufreq-info
cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to linux@brodo.de, please.
analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which need to switch frequency at the same time: 0 1
  hardware limits: 1000 MHz - 1.67 GHz
  available frequency steps: 1.67 GHz, 1.33 GHz, 1000 MHz
  available cpufreq governors: userspace, powersave, ondemand,
conservative, performance
  current policy: frequency should be within 1.67 GHz and 1.67 GHz.
                  The governor "userspace" may decide which speed to use
                  within this range.
  current CPU frequency is 1.67 GHz (asserted by call to hardware).
analyzing CPU 1:
  driver: acpi-cpufreq
  CPUs which need to switch frequency at the same time: 0 1
  hardware limits: 1000 MHz - 1.67 GHz
  available frequency steps: 1.67 GHz, 1.33 GHz, 1000 MHz
  available cpufreq governors: userspace, powersave, ondemand,
conservative, performance
  current policy: frequency should be within 1.67 GHz and 1.67 GHz.
                  The governor "userspace" may decide which speed to use
                  within this range.
  current CPU frequency is 1.67 GHz (asserted by call to hardware).

root@hokage:~# grep rate /proc/acpi/battery/BAT1/state
present rate:            1693 mA


* turn off CPU#1
root@hokage:~# echo 0 > /sys/devices/system/cpu/cpu1/online
root@hokage:~# grep rate /proc/acpi/battery/BAT1/state
present rate:            2084 mA

* turn CPU#1 back on:
root@hokage:~# echo 1 > /sys/devices/system/cpu/cpu1/online
root@hokage:~# grep processor /proc/cpuinfo
processor       : 0
processor       : 1
root@hokage:~# grep rate /proc/acpi/battery/BAT1/state
present rate:            1653 mA


Question: is that normal? I thought power consumption will be
automatically reduced if one core offlined.

Thanks.
Andika
