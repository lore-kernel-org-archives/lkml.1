Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYCTKjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYCTKjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 06:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYCTKjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 06:39:09 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:33722 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYCTKjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 06:39:07 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2008 06:39:07 EDT
Date: Thu, 20 Mar 2008 10:28:58 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
X-X-Sender: macro@piorun
To: Glauber de Oliveira Costa <gcosta@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ak@suse.de
Subject: Re: [PATCH 45/79] [PATCH] fix apic acking of irqs
In-Reply-To: <12059477792893-git-send-email-gcosta@redhat.com>
Message-ID: <alpine.SOC.1.00.0803201016540.12075@piorun>
References: <12059475744092-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com>
 <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com>
 <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com>
 <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send! -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat <12059477792893-git-send-email-gcosta@redhat.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, Glauber de Oliveira Costa wrote:

> EOI is a write-only register. Using write around will have the effect
> of reading it, which will make all subsequent reads of the ESR register
> to return an error code. It was unnotices for quite a while because main sources
> of reading the ESR register where done prior to apic interrupt enabling.

 Are you sure this actually triggers for APIC chips affected by the 
erratum in question?  And please note that for them the effect of two 
consecutive writes will be much more disastrous than setting a bit in the 
ESR register.

  Maciej
