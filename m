Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbZFRLfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbZFRLfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZFRLfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:35:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38916 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbZFRLfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:35:09 -0400
Message-ID: <4A3A2685.4060500@redhat.com>
Date: Thu, 18 Jun 2009 14:35:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v7 1/2] KVM: make io_bus interface more robust
References: <20090616133751.14362.12674.stgit@dev.haskins.net> <20090616134230.14362.39612.stgit@dev.haskins.net>
In-Reply-To: <20090616134230.14362.39612.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2009 04:42 PM, Gregory Haskins wrote:
> +
> +/* assumes kvm->lock held */
> +void kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
> +			       struct kvm_io_device *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i<  bus->dev_count; i++) {
> +
> +		if (bus->devs[i] == dev) {
> +			int j;
> +
> +			/* backfill the hole */
> +			for (j = i; j<  bus->dev_count-1; j++)
> +				bus->devs[j] = bus->devs[j+1];
> +
> +			bus->dev_count--;
> +
> +			break;
>    

Could be simplified to

     if (bus->devs[i] == dev) {
         bus->devs[i] = bus->devs[--bus->dev_count];
         return;
     }

-- 
error compiling committee.c: too many arguments to function

