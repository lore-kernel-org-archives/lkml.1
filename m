Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0APPgB (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 10:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998Ab0APPf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 10:35:59 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57403 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab0APPf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:35:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B51DCBF.9090902@s5r6.in-berlin.de>
Date: Sat, 16 Jan 2010 16:35:27 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: linux-kernel@vger.kernel.org, Willem Riede <osst@riede.org>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi/osst.c: remove unncessary casting of kmalloc.
References: <503939f4cfd0b8c362a2f5a103285f8dc330b99a.1263651173.git.tfransosi@gmail.com>
In-Reply-To: <503939f4cfd0b8c362a2f5a103285f8dc330b99a.1263651173.git.tfransosi@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago Farina wrote:
> --- a/drivers/scsi/osst.c
> +++ b/drivers/scsi/osst.c
> @@ -5842,9 +5842,8 @@ static int osst_probe(struct device *dev)
>  	/* if this is the first attach, build the infrastructure */
>  	write_lock(&os_scsi_tapes_lock);
>  	if (os_scsi_tapes == NULL) {
> -		os_scsi_tapes =
> -			(struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
> -				   GFP_ATOMIC);
> +		os_scsi_tapes = kmalloc(osst_max_dev * sizeof(struct osst_tape *),
> +					GFP_ATOMIC);
>  		if (os_scsi_tapes == NULL) {
>  			write_unlock(&os_scsi_tapes_lock);
>  			printk(KERN_ERR "osst :E: Unable to allocate array for OnStream SCSI tapes.\n");

Since you update the style of this kmalloc usage, you could at the same
time change the sizeof expression to sizeof(* os_scsi_tapes).

There is a lot more that could be renovated around os_scsi_tapes, and
osst in general (GFP_ATOMIC allocations in a device probe?  Fixed
maximum number of devices?  BKL usage?), but whether it'd be worth the
effort I don't know.
-- 
Stefan Richter
-=====-==-=- ---= =----
http://arcgraph.de/sr/
