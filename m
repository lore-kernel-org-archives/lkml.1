Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbXCROwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbXCROwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 10:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbXCROwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 10:52:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:43586 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbXCROwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 10:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ElgfNv9TqoJdTyyoVbNTQLVEi858wwC8OdqPn360iI345DaeJIZ1+qdYzvkuWUYzBSLTd5ZgpTD7TiZLteqmOItIyTNYuyuSXzoU2txcfRbBxnxHJP007UZFSNtUAcmib+dXc1aPdUJ7apoaSJinoWDPbugfUVAzx+5kCl/zD1M=
Message-ID: <3877989d0703180752k1cc55557kade3071f00a95e97@mail.gmail.com>
Date: Sun, 18 Mar 2007 22:52:16 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: ACPI initialization failure with v2.6.21-rc4
In-Reply-To: <20070318102532.GB27142@leiferikson>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070318102532.GB27142@leiferikson>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do you recall which acpi enabled kernel works for you?
If never, I guess your system don't support ACPI .
If yes, this should be resolved. Please enter a acpi bug into
bugzilla.kernel.org with sufficient info : dmesg,lspci -vvx,
/proc/ioports, acpidump output... w/ acpi=off.

On 3/18/07, Johannes Weiner <hannes-kernel@saeurebad.de> wrote:
> [resend due to wrong mail headers last time]
>
> Hi,
>
> The kernel version mentioned in the subject won't boot because the ACPI
> system does not get initialized; the system freezes on an outb() in
> acpi_os_write_port() i.e. it does not do anything anymore and just hangs.
>
> Here is the `stack trace' I managed to extract via debugging output:
>
>         -- acpi_os_write_port(0xb2, 240, 8)
>         -- acpi_hw_set_mode(ACPI_SYS_MODE_ACPI)
>         -- acpi_enable()
>         -- acpi_enable_subsystem(~ACPI_NO_ACPI_ENABLE)
>         -- acpi_early_init()
>         ...
>
> Notes:
>         * acpi_os_write_port(): I printk'd the arguments; the port
>           formatted with %#x and the value with %u.
>
>         * acpi_enable_subsystem(): I removed ACPI_NO_HARDWARE_INIT
>           from the arguments because it is not used anymore.
>           In this context I want to mention that it probably can be
>           removed from include/acpi/actypes.h generally.
>
> Random question:
>
>         I noticed that acpi_gbl_FADT is declared in
>         include/acpi/acglobal.h but where is it actually defined and
>         initialized?
>
> HTH,
> Hannes
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
