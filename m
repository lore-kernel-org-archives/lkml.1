Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbYKRFqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbYKRFqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 00:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYKRFqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 00:46:15 -0500
Received: from main.gmane.org ([80.91.229.2]:50135 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYKRFqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 00:46:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ACPI suspend: Blacklist boxes that require us to set
 SCI_EN directly on resume
Date: Mon, 17 Nov 2008 23:45:59 -0600
Message-ID: <49225697.90804@shaw.ca>
References: <200811172333.13466.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-acpi@vger.kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
In-Reply-To: <200811172333.13466.rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: ACPI suspend: Blacklist boxes that require us to set SCI_EN directly on resume
> 
> Some Apple boxes evidently require us to set SCI_EN on resume
> directly, because if we don't do that, they hung somewhere in the
> resume code path.  Moreover, on these boxes it is not sufficient to
> use acpi_enable() to turn ACPI on during resume.  All of this is
> against the ACPI specification which states that (1) the BIOS is
> supposed to return from the S3 sleep state with ACPI enabled
> (SCI_EN set) and (2) the SCI_EN bit is owned by the hardware and we
> are not supposed to change it.
> 
> For this reason, blacklist the affected systems so that the SCI_EN
> bit is set during resume on them.
> 
> [NOTE: Unconditional setting SCI_EN for all system on resume doesn't
>  work, because it makes some other systems crash (that's to be
>  expected).  Also, it is not entirely clear right now if all of the
>  Apple boxes require this workaround.]

This is rather gross. The usual question arises, why does Windows work 
without such a hack? Maybe there is no better solution for now, but 
somebody should really look into why the behavior is different in Linux..

