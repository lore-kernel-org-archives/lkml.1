Return-Path: <linux-kernel-owner+w=401wt.eu-S936996AbXHLSpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936996AbXHLSpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 14:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXHLSpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 14:45:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49210 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867AbXHLSpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 14:45:43 -0400
Date: Sun, 12 Aug 2007 11:49:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: len.brown@intel.com
Subject: Re: ACPI: thermal: create "thermal.off=1" to disable ACPI thermal
 support
Message-Id: <20070812114948.fe7e8bec.randy.dunlap@oracle.com>
In-Reply-To: <200708121059.l7CAxB3i003857@hera.kernel.org>
References: <200708121059.l7CAxB3i003857@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 10:59:11 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=72b33ef8bb1ac7f6c5a16d23304ab25ddc73d93d
> Commit:     72b33ef8bb1ac7f6c5a16d23304ab25ddc73d93d
> Parent:     3864e8ccbba1dcdea87398ab80fdc8ae0fab7c45
> Author:     Len Brown <len.brown@intel.com>
> AuthorDate: Sun Aug 12 00:12:17 2007 -0400
> Committer:  Len Brown <len.brown@intel.com>
> CommitDate: Sun Aug 12 00:12:17 2007 -0400
> 
>     ACPI: thermal: create "thermal.off=1" to disable ACPI thermal support
>     
>     "thermal.off=1" disables all ACPI thermal support at boot time.
>     
>     CONFIG_ACPI_THERMAL=n can do this at build time.
>     "# rmmod thermal" can do this at run time,
>     as long as thermal is built as a module.
>     
>     WARNING: On some systems, disabling ACPI thermal support
>     will cause the system to run hotter and reduce the
>     lifetime of the hardware.
>     
>     Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  Documentation/kernel-parameters.txt |    3 +++
>  drivers/acpi/thermal.c              |    9 ++++++++-
>  2 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 5a62de1..61337d9 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -78,6 +78,10 @@ static int tzp;
>  module_param(tzp, int, 0);
>  MODULE_PARM_DESC(tzp, "Thermal zone polling frequency, in 1/10 seconds.\n");
>  
> +static int off;
> +module_param(off, int, 0);
> +MODULE_PARM_DESC(off, "Set to disable ACPI thermal support.\n");
> +
>  static int acpi_thermal_add(struct acpi_device *device);
>  static int acpi_thermal_remove(struct acpi_device *device, int type);
>  static int acpi_thermal_resume(struct acpi_device *device);

Hi,

What's the purpose of the "\n" in the MODULE_PARM_DESC() string?

modinfo already terminates module parameter listings with a newline
after each parameter description.  Some people insert newlines inside
these strings for pretty printing (which I don't find necessary),
but using a newline at the end of the string only makes the
parameter type (that is added by modinfo) appear on a separate line,
which IMO is worse that having it appear at the end of the parameter
line.  E.g.,

$ modinfo -p asus_acpi.ko
asus_uid:UID for entries in /proc/acpi/asus.

asus_gid:GID for entries in /proc/acpi/asus.

$

but when the newline is omitted, it would be printed as

$ modinfo -p asus_acpi.ko
asus_uid:UID for entries in /proc/acpi/asus.
asus_gid:GID for entries in /proc/acpi/asus.
$


or when -p is not used (but only showing the parm lines here):

$ modinfo asus_acpi.ko
parm:           asus_gid:GID for entries in /proc/acpi/asus.
 (uint)
parm:           asus_uid:UID for entries in /proc/acpi/asus.
 (uint)
$

or if the newline is not used in the string:

$ modinfo asus_acpi.ko
parm:           asus_gid:GID for entries in /proc/acpi/asus. (uint)
parm:           asus_uid:UID for entries in /proc/acpi/asus. (uint)
$

where I posit that the latter is better than the former...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
