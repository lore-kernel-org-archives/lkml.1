Return-Path: <linux-kernel-owner+w=401wt.eu-S938827AbXG3QdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938827AbXG3QdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761675AbXG3QdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:33:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43720 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760353AbXG3Qc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:32:59 -0400
Message-ID: <46AE12B6.6090408@garzik.org>
Date: Mon, 30 Jul 2007 12:32:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
References: <20070705194909.337398431@intel.com> <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
In-Reply-To: <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> @@ -42,6 +42,16 @@ enum scsi_eh_timer_return {
>  	EH_RESET_TIMER,
>  };
>  
> +/*
> + * shost pm policy: If you alter this, you also need to alter scsi_sysfs.c
> + * (for the ascii descriptions)
> + */
> +enum scsi_host_link_pm {
> +	SHOST_NOT_AVAILABLE,
> +	SHOST_MIN_POWER,
> +	SHOST_MAX_PERFORMANCE,
> +	SHOST_MEDIUM_POWER,
> +};
>  
>  struct scsi_host_template {
>  	struct module *module;
> @@ -345,6 +355,12 @@ struct scsi_host_template {
>  	int (*suspend)(struct scsi_device *, pm_message_t state);
>  
>  	/*
> + 	 * link power management support
> + 	 */
> +	int (*set_link_pm_policy)(struct Scsi_Host *, enum scsi_host_link_pm);
> +	enum scsi_host_link_pm default_link_pm_policy;
> +
> +	/*
>  	 * Name of proc directory
>  	 */
>  	char *proc_name;
> @@ -642,6 +658,7 @@ struct Scsi_Host {
>  	
>  
>  	enum scsi_host_state shost_state;
> +	enum scsi_host_link_pm shost_link_pm_policy;
>  
>  	/* ldm bits */
>  	struct device		shost_gendev;


Any chance the SCSI peeps could ACK this, and then let me include it in 
the ALPM patchset in the libata tree?

	Jeff


