Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbXEPUsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbXEPUsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbXEPUso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:48:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641AbXEPUsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:48:43 -0400
Date: Wed, 16 May 2007 16:48:07 -0400
From: Dave Jones <davej@redhat.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: Prakash Punnoor <prakash@punnoor.de>,
       Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States driver
Message-ID: <20070516204807.GA23751@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Duane Griffin <duaneg@dghda.com>,
	Prakash Punnoor <prakash@punnoor.de>,
	Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>,
	LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@gentoo.org>
References: <20070516011711.GE15763@ifa.hawaii.edu> <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 08:53:13PM +0100, Duane Griffin wrote:
 > On 16/05/07, Prakash Punnoor <prakash@punnoor.de> wrote:
 > > Maybe you want to give a hint in the p states driver help text?
 > 
 > I think a hint is the right thing to do, but in the PowerNow! driver
 > rather than the p states one. How about adding something like this to
 > the X86_POWERNOW_K8 (and X86_POWERNOW_K7?) help text:

The mobile K7s which had powernow support weren't SMP capable, so they're
irrelevant.

 > "ACPI support is required for non-UP systems and requires ACPI_PROCESSOR
 >  to be selected. If ACPI_PROCESSOR is compiled as a module then this
 >  option must be too in order for ACPI support to be available."

X86_POWERNOW_K8_ACPI is already 'default y'. I think the problem lies in
that people aren't enabling its dependancy, ACPI_PROCESSOR.

We want something along the lines of..

config X86_POWERNOW_K8_ACPI
	bool
	if SMP & X86_POWERNOW_K8_ACPI
	  select ACPI_PROCESSOR

kconfig language quirks aside..


	Dave

-- 
http://www.codemonkey.org.uk
