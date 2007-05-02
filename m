Return-Path: <linux-kernel-owner+w=401wt.eu-S1766663AbXEBWbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766663AbXEBWbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766703AbXEBWbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:31:07 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:50598 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766663AbXEBWbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:31:06 -0400
Message-ID: <4639111A.70202@nortel.com>
Date: Wed, 02 May 2007 16:30:50 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Glen Turner <gdt@gdt.id.au>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Detecting process death for anycast named process monitoring
References: <4638FCEA.4010806@gdt.id.au>
In-Reply-To: <4638FCEA.4010806@gdt.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 May 2007 22:30:55.0048 (UTC) FILETIME=[8C3E8C80:01C78D09]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glen Turner wrote:

> The question is, how can a process with no relationship to another
> process detect that process unexpectedly dying?  If named goes
> away to a better place, we want to shut down the interface
> which causes Quagga to inject the anycast route.
> 
> We don't want to be the parent of the running process, because that
> doesn't add robustness. If the parent process dies, then the service
> dies, and the interface still stays up.
> 
> We don't want to poll, because that isn't pretty and the polling
> interval needs to be very short on a big ISP's DNS servers.

We did something similar where arbitrary processes can register to be 
sent an arbitrary signal when the state of other processes change.  The 
caller passes in the pid, the signal to be sent, and an event mask 
describing which events you're interested in (stop/start/exit/kill/etc.).

A signal number of 0 means to deregister interest in the specified pid.

Chris
