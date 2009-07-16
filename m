Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbZGPOcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbZGPOcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932106AbZGPOcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:32:08 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:52359 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbZGPOcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:32:07 -0400
Message-ID: <4A5F3975.70503@s5r6.in-berlin.de>
Date: Thu, 16 Jul 2009 16:30:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1247701438-18266-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> Userspace may wish to make policy decisions based on whether a host
> supports device hotplug or not - for example, AHCI link power management
> disables hotplug, so may only be desirable on hotplug ports. Add
> support for marking hosts as hotpluggable in order to allow userspace to
> treat them appropriately.
[...]
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -421,6 +421,7 @@ struct scsi_host_template {
>  	 */
>  	unsigned unchecked_isa_dma:1;
>  
> +
>  	/*
>  	 * True if this host adapter can make good use of clustering.
>  	 * I originally thought that if the tablesize was large that it
> @@ -447,6 +448,11 @@ struct scsi_host_template {
>  	unsigned ordered_tag:1;
>  
>  	/*
> +	 * True if host supports hotplugging
> +	 */
> +	unsigned hotpluggable:1;
> +

The comment should specify what the actual effects of the flag are.

(Provides the default for Scsi_Host.hotpluggable?)

> +	/*
>  	 * Countdown for host blocking with no commands outstanding.
>  	 */
>  	unsigned int max_host_blocked;
> @@ -622,6 +628,9 @@ struct Scsi_Host {
>  	/* Asynchronous scan in progress */
>  	unsigned async_scan:1;
>  
> +	/* 1 if hotpluggable, 0 if not */
> +	unsigned hotpluggable:1;
> +

Ditto here.

(Is used by power management infrastructure to decide over runtime PM
policy?  I.e. don't enter power states which would prevent the port from
detecting/ reporting hotplug events?)

>  	/*
>  	 * Optional work queue to be utilized by the transport
>  	 */


-- 
Stefan Richter
-=====-==--= -=== =----
http://arcgraph.de/sr/
