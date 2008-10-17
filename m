Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbYJQS3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbYJQS3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYJQS25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:28:57 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:35947 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbYJQS24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:28:56 -0400
Date: Fri, 17 Oct 2008 12:28:55 -0600
From: Alex Chiang <achiang@hp.com>
To: Anil kumar <anils_r@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-pci <linux-pci@vger.kernel.org>
Subject: Re: MSI-X msix_entry.vector population
Message-ID: <20081017182855.GD2137@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Anil kumar <anils_r@yahoo.com>, linux-kernel@vger.kernel.org,
	linux-pci <linux-pci@vger.kernel.org>
References: <886149.56834.qm@web32407.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <886149.56834.qm@web32407.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cc'ing linux-pci

* Anil kumar <anils_r@yahoo.com>:
> Hi,
> 
> In the driver, during interrupt registration for MSIX we get
> the vector numbers assigned from the kernel and we associate
> the entry and interrupt handlers with this vector.
> 
> I want to achieve the following logic in the driver: 
> In the queuecommand I assign MSIX vector for each command
> before sending it down. The reason why I want to do this is I
> want to get the response back in that particular MSIX vector
> entry interrupt handler only. For example If I am sending two
> commands down, command1 will have MSIX_vector_1 and command2
> will have MSIX_vector_2. The interrupt handlers registered are
> MSIX_vector_1_Int1 and MSIX_vector_2_Int2. When command is
> complete the response should come back in the respective
> interrupt handlers registered for MSIX_vector_1 and
> MSIX_vector_2 only. 
> 
> To achieve this, I will take msix_entries.[1].vector and assign
> it to command1 in queuecommand and msix_entries.[2].vector and
> assign it to command2.

> 
> Question:
> Now if I have a Dual core CPU, CORE1 and CORE2 each with
> vectors 0 to 4 on them. When I shoot a command with
> msix_entries[1].vector will the completion for this command
> come from CORE1 core vector1 or it can come from CORE2 vector1.
> Is it okay if we get response(triggered interrupt handler) back
> from CORE2. Will I have any routing issues here?
> 
> -or- 
> 
> Is there a way wherein I can call some function to make sure
> that let the kernel assign MSIX.vector for my command in proper
> distributed way in my queuecommand.
> 
> with regards, Anil
> 
>  
> 
> 
>       
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html Please read the FAQ
> at  http://www.tux.org/lkml/
> 
