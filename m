Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYHGUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYHGUKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYHGUKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:10:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4070 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751708AbYHGUKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:10:07 -0400
Date: Wed, 6 Aug 2008 18:56:49 +0200
From: Pavel Machek <pavel@suse.cz>
To: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20080806165648.GA9178@ucw.cz>
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Fixed more issues raised on lkml after previous submission.
> 
> 
> The Intel Management Engine Interface (aka HECI: Host Embedded
> Controller Interface ) enables communication between the host OS and
> the Management Engine firmware. MEI is bi-directional, and either the
> host or Intel AMT firmware can initiate transactions.
> 
> The core hardware architecture of Intel Active Management Technology
> (Intel AMT) is resident in firmware. The micro-controller within the
> chipset's graphics and memory controller (GMCH) hub houses the
> Management Engine (ME) firmware, which implements various services
> on behalf of management applications.
> 
> Some of the ME subsystems that can be access via MEI driver:
> 
> - Intel(R) Quiet System Technology (QST) is implemented as a firmware
> subsystem  that  runs in the ME.  Programs that wish to expose the
> health monitoring and fan speed control capabilities of Intel(R) QST
> will need to use the MEI driver to communicate with the ME sub-system.
> - ASF is the "Alert Standard Format" which is an DMTF manageability
> standard. It is implemented in the PC's hardware and firmware, and is
> managed from a remote console.

Cool, so this should hook into sensors subsystem, right?

Also it uses __x32-style types when x32 would be enough.

> +	heci_check_asf_mode(dev);
> +	/*heci initialization wd */

That is not exactly helpful comment... Decrypt? Space after /*?


> +	DBG("call wait_event_interruptible_timeout for response message.\n");
> +	/* wait for response */

Home-brewn DBG is un-nice.

> +static int host_enum_clients_message(struct iamt_heci_device *dev)
> +{
> +	long timeout = 5;	/*5 second */
> +	struct heci_msg_hdr *heci_hdr;
> +	struct hbm_host_enum_request *host_enum_req;
> +	int err = 0;
> +	__u8 i, j;

int is probably better here.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
