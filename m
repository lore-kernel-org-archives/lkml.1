Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZEXMM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZEXMM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 08:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZEXMMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 08:12:21 -0400
Received: from h155.mvista.com ([63.81.120.155]:11203 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752375AbZEXMMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 08:12:19 -0400
Message-ID: <4A19399B.8060207@ru.mvista.com>
Date: Sun, 24 May 2009 16:12:11 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/ide/ide-core: Unsplit constant strings for
 pr_<level> and dev_<level>
References: <cover.1243062772.git.joe@perches.com> <57f9dd5c33bcdd863793a3ee95ab050e8456bab4.1243062772.git.joe@perches.com>
In-Reply-To: <57f9dd5c33bcdd863793a3ee95ab050e8456bab4.1243062772.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
>   
[...]
> diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
> index f323a60..560b9c4 100644
> --- a/drivers/ide/ide-acpi.c
> +++ b/drivers/ide/ide-acpi.c
> @@ -435,8 +435,8 @@ void ide_acpi_get_timing(ide_hwif_t *hwif)
>  	if (!out_obj->buffer.length || !out_obj->buffer.pointer ||
>  	    out_obj->buffer.length != sizeof(struct GTM_buffer)) {
>  		kfree(output.pointer);
> -		pr_err("%s: unexpected _GTM length (0x%x)[should be 0x%zx] or "
> -		       "addr (0x%p)\n",
> +		pr_err(
> +	"%s: unexpected _GTM length (0x%x)[should be 0x%zx] or addr (0x%p)\n",
>   

   Oh no... do you really think somebody will search for this message 
using strings like "should be"?

>  		       __func__, out_obj->buffer.length,
>  		       sizeof(struct GTM_buffer), out_obj->buffer.pointer);
>  		return;
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index 46cf46e..1e9e2d6 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -60,11 +60,13 @@ int ide_check_atapi_device(ide_drive_t *drive, const char *s)
>  		dev_err(&drive->gendev, "%s: the removable flag is not set\n",
>  			s);
>  	else if (drive->media == ide_floppy && drq_type == 3)
> -		dev_err(&drive->gendev, "%s: sorry, DRQ type (0x%02x) not "
> -			"supported\n", s, drq_type);
> +		dev_err(&drive->gendev,
> +			"%s: sorry, DRQ type (0x%02x) not supported\n",
>   

   Same question. I think the user will search for "sorry, DRQ type".

> +			s, drq_type);
>  	else if (packet_size != 0)
> -		dev_err(&drive->gendev, "%s: packet size (0x%02x) is not 12 "
> -			"bytes\n", s, packet_size);
> +		dev_err(&drive->gendev,
> +			"%s: packet size (0x%02x) is not 12 bytes\n",
>   

   When the message is broken by the format specifier, turning it into 
one liner can hardly help seraching...

> @@ -439,8 +440,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
>  	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
>  		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
>  		dev_err(&drive->gendev,
> -			"The device wants to issue more interrupts "
> -			"in DMA mode\n");
> +	"The device wants to issue more interrupts in DMA mode\n");
>   

   Oh noes, the indentation...

> @@ -509,14 +509,12 @@ static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
>  	while (retries-- && ((ireason & ATAPI_COD) == 0 ||
>  			     (ireason & ATAPI_IO))) {
>  		dev_err(&drive->gendev,
> -			"(IO,CoD != (0,1) while issuing "
> -			"a packet command, retrying\n");
> +	"(IO,CoD != (0,1) while issuing a packet command, retrying\n");
>   

   Sigh...

>  		udelay(100);
>  		ireason = ide_read_ireason(drive);
>  		if (retries == 0) {
>  			dev_err(&drive->gendev,
> -				"(IO,CoD != (0,1) while issuing "
> -				"a packet command, ignoring\n");
> +	"(IO,CoD != (0,1) while issuing a packet command, ignoring\n");
>   

   Sigh...

> @@ -547,8 +545,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
>  
>  	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
>  		dev_err(&drive->gendev,
> -			"Strange, packet command initiated yet "
> -			"DRQ isn't asserted\n");
> +	"Strange, packet command initiated yet DRQ isn't asserted\n");
>   

   Sigh...

> @@ -590,8 +587,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
>  
>  		if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
>  			dev_err(&drive->gendev,
> -				"(IO,CoD) != (0,1) while issuing "
> -				"a packet command\n");
> +		"(IO,CoD) != (0,1) while issuing a packet command\n");
>   

   Sigh...

> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index 51c7cb4..07565c9 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -743,8 +743,9 @@ static void unexpected_intr(int irq, ide_hwif_t *hwif)
>  
>  		if (time_after(jiffies, last_msgtime + HZ)) {
>  			last_msgtime = jiffies;
> -			dev_err(&hwif->gendev, "unexpected interrupt, "
> -				"status=0x%02x, count=%ld\n", stat, count);
> +			dev_err(&hwif->gendev,
> +		"unexpected interrupt, status=0x%02x, count=%ld\n",
>   


   Hardly won anything...

> diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
> index 6dbb96e..c5ab2ec 100644
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -259,8 +259,8 @@ no_80w:
>  	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
>  		return 0;
>  
> -	dev_warn(&drive->gendev, "%s side 80-wire cable detection failed, "
> -		 "limiting max speed to UDMA33\n",
> +	dev_warn(&drive->gendev,
> + "%s side 80-wire cable detection failed, limiting max speed to UDMA33\n",
>   

    Will you really use the full message to serch here?

> diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
> index c4b44e2..a4120e2 100644
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -271,8 +271,9 @@ int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
>  		s = tp_ops->read_status(hwif);
>  		if ((a ^ s) & ~ATA_IDX)
>  			/* ancient Seagate drives, broken interfaces */
> -			dev_info(&drive->gendev, "probing with STATUS(0x%02x) "
> -				 "instead of ALTSTATUS(0x%02x)\n", s, a);
> +			dev_info(&drive->gendev,
> +		 "probing with STATUS(0x%02x) instead of ALTSTATUS(0x%02x)\n",
>   

   Same comment about the line broken by the format specifiers. This 
wins absolutely nothing.

> @@ -415,8 +416,8 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
>  
>  		if (rc == 1 && cmd == ATA_CMD_ID_ATAPI) {
>  			dev_err(&drive->gendev,
> -				"no response (status = 0x%02x), "
> -				"resetting drive\n", stat);
> +		"no response (status = 0x%02x), resetting drive\n",
>   

   And again...

> diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
> index 23b9d6a..cd580b1 100644
> --- a/drivers/ide/ide-proc.c
> +++ b/drivers/ide/ide-proc.c
> @@ -464,8 +464,7 @@ static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
>  	strlcpy(drive->driver_req, driver, sizeof(drive->driver_req));
>  	err = device_attach(dev);
>  	if (err < 0)
> -		pr_warning("IDE: %s: device_attach error: %d\n",
> -			   __func__, err);
> +		pr_warning("IDE: %s: device_attach error: %d\n", __func__, err);
>   

   I'm nt sure why this isn't a part of printk(KERN_*, ...); to 
pr_*(...) conversion patch. You're not unsplitting the constant here.

> diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
> index 8d741d1..687b3be 100644
> --- a/drivers/ide/ide-taskfile.c
> +++ b/drivers/ide/ide-taskfile.c
> @@ -579,8 +579,9 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
>  		case TASKFILE_MULTI_OUT:
>  			if (!drive->mult_count) {
>  				/* (hs): give up if multcount is not set */
> -				dev_err(&drive->gendev, "%s Multimode Write " \
> -					"multcount is not set\n", __func__);
> +				dev_err(&drive->gendev,
> +			"%s Multimode Write multcount is not set\n",
>   

   Sigh...

> @@ -599,8 +600,8 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
>  			if (!drive->mult_count) {
>  				/* (hs): give up if multcount is not set */
>  				dev_err(&drive->gendev,
> -					"%s Multimode Read failure "
> -					"multcount is not set\n", __func__);
> +			"%s Multimode Read failure multcount is not set\n",
> +					__func__);
>   

   Sigh...

> diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
> index f139cf3..3aca89a 100644
> --- a/drivers/ide/setup-pci.c
> +++ b/drivers/ide/setup-pci.c
> @@ -39,17 +39,18 @@ static int ide_setup_pci_baseregs(struct pci_dev *dev, const char *name)
>  	if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
>  			 (progif & 5) != 5) {
>  		if ((progif & 0xa) != 0xa) {
> -			pr_info("%s %s: device not capable of full "
> -				"native PCI mode\n", name, pci_name(dev));
> +			pr_info(
> +		"%s %s: device not capable of full native PCI mode\n",
>   

   Sigh...

>  		(void) pci_write_config_byte(dev, PCI_CLASS_PROG, progif|5);
>  		if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
>  		    (progif & 5) != 5) {
> -			pr_err("%s %s: rewrite of PROGIF failed, "
> -			       "wanted 0x%04x, got 0x%04x\n",
> +			pr_err(
> +		"%s %s: rewrite of PROGIF failed, wanted 0x%04x, got 0x%04x\n",
>   

   The same comment about the string broken by yhe format specifiers. 
This wins nothing, well, almost...

> @@ -322,8 +323,8 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
>  	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
>  		if (ide_pci_check_iomem(dev, d, 2 * port) ||
>  		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
> -			pr_err("%s %s: I/O baseregs (BIOS) are "
> -			       "reported as MEM for port %d!\n",
> +			pr_err(
> +		"%s %s: I/O baseregs (BIOS) are reported as MEM for port %d!\n",
>   

   Sigh...

> @@ -519,8 +520,9 @@ static int do_ide_setup_pci_device(struct pci_dev *dev,
>  
>  	if (ide_pci_is_in_compatibility_mode(dev)) {
>  		if (noisy)
> -			pr_info("%s %s: not 100%% native mode: will "
> -				"probe irqs later\n", d->name, pci_name(dev));
> +			pr_info(
> +		"%s %s: not 100%% native mode: will probe irqs later\n",
>   

   Sigh...

MBR, Sergei


