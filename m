Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZDLSh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZDLSh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZDLShR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:37:17 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34319 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZDLShP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dxIaQi0XGEZXedI+8I+uZ9xFsyveztz1LtrpZsZaedl/OGDAU4+jo6aOJwzgbAn5BL
         DROdmGFjA4Dz/5dtGi8nWNict3S8AO0Y+oFORSSzvTEAIcHjoCoZKKAXImdsDagqmJAq
         teFxomGh+ff0bDTBueGNSMQGhII+sspLUZJ1E=
Message-ID: <49E234ED.5010105@gmail.com>
Date: Sun, 12 Apr 2009 20:37:33 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control	brightness
 with hotkeys
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org> <20090412161448.GC26502@khazad-dum.debian.net>
In-Reply-To: <20090412161448.GC26502@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2009 06:14 PM, Henrique de Moraes Holschuh wrote:
> On Sat, 11 Apr 2009, Andrew Morton wrote:
>   
>>> With latest git kernel, I'm no longer able to control my Thinkpad (W500)
>>> brightness, although I can still control the backlight, bluetooth etc.
>>>       
>
> Niels, something just occourred to me.  Is your problem the hotkeys, or the
> brightness control itself?  Check /sys/class/backlight/*, please.  What do
> you have in there?  Does it work?
>   
Hi Henrique,

The directory is empty - this is when I used 2.6.30-rc1 (latest git)
from yesterday. I'll keep retrying with the latest git kernels though.

The only additional observations I can provide is:
1) pulling/plugging the power cord does actually have an effect on the
brightness.
2) resuming form hibernate - Xorg is blank, until I simultaneously press
a keyboard key and touch the synaptics pad. But I have this problem in
2.6.28/2.6.29 as well, and I guess it could either be vesafb or ACPI
related, as it also happened when I used s2disk in a console session
outside of X.

In 2.6.29.1:
lrwxrwxrwx 1 root root 0 Apr 12 20:01 /sys/class/backlight/acpi_video0
-> ../../devices/virtual/backlight/acpi_video0

which contains:
drwxr-xr-x 3 root root    0 Apr 12 20:01 ./
drwxr-xr-x 3 root root    0 Apr 12 20:01 ../
-r--r--r-- 1 root root 4096 Apr 12 20:02 actual_brightness
-rw-r--r-- 1 root root 4096 Apr 12 20:02 bl_power
-rw-r--r-- 1 root root 4096 Apr 12 20:02 brightness
-r--r--r-- 1 root root 4096 Apr 12 20:01 max_brightness
drwxr-xr-x 2 root root    0 Apr 12 20:02 power/
lrwxrwxrwx 1 root root    0 Apr 12 20:01 subsystem ->
../../../../class/backlight/
-rw-r--r-- 1 root root 4096 Apr 12 20:01 uevent

max_brightness = 15 and echoing values [0-15] to brightness controls it
as expected, or just using the standard thinkpad keys (Fn-Home to increase).
> If it is the hotkeys, make sure you either have the legacy ACPI events
> enabled in kconfig, or that you have something tied to the thinkpad-acpi
> input device (no, HAL doesn't do it _yet_, it just forwards the events to
> X.org)...
>   
I'm not sure what provides the "glue", other than "it works" in 2.6.29.1
and 2.6.28.9 with OpenSUSE 11.1 with xorg-x11-server-7.4-41.8.

Would it help if I send the ACPI parts of my .config? These are based on
the default /proc/config.gz that comes with the distro.

# Power management and ACPI
options                                                               
CONFIG_ACPI=y                                                                                     

CONFIG_ACPI_SLEEP=y                                                                               

CONFIG_ACPI_PROCFS=y                                                                              

CONFIG_ACPI_PROCFS_POWER=y                                                                        

CONFIG_ACPI_SYSFS_POWER=y                                                                         

CONFIG_ACPI_PROC_EVENT=y                                                                          

CONFIG_ACPI_AC=m                                                                                  

CONFIG_ACPI_BATTERY=m                                                                             

CONFIG_ACPI_BUTTON=m                                                                              

CONFIG_ACPI_VIDEO=m                                                                               

CONFIG_ACPI_FAN=m                                                                                 

CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=2001
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_PNPACPI=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_ATA_ACPI=y
CONFIG_PATA_ACPI=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_ACPI_WMI=m
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m

Regards,
Niel
