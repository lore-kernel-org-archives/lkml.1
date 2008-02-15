Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbYBOCPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbYBOCPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 21:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYBOCPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 21:15:01 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:38792 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbYBOCPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 21:15:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K/8A2DqV+sGnXhLp8psLeWx3tNROOqSvIGyKswlqKD7iE1lQ5xoCnNOIg2hnLLVL9B2Zm3ejTTcoy/q3fWh8WLLCOyCpJCiebNNvdrOcJHGVDNq6i1iAPtg1plMP3Rjw+1g2X4kyesv8FxdisBV3bzqo2YsAQys8zhGhyBcgKPE=
Message-ID: <86802c440802141814t39b8082bx7ceb7eaf37c1142c@mail.gmail.com>
Date: Thu, 14 Feb 2008 18:14:59 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Cc: "Greg KH" <gregkh@suse.de>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20080214234832.GA14363@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802111623.38478.elendil@planet.nl>
	 <200802122139.14840.elendil@planet.nl>
	 <20080212205622.GA21986@suse.de>
	 <200802131239.14305.elendil@planet.nl>
	 <20080213165837.GA10129@suse.de>
	 <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com>
	 <20080214234832.GA14363@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 3:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > after disable cpufreq, i got
>  >
>  > ACPI: Preparing to enter system sleep state S5
>  > Disabling non-boot CPUs ...
>  > kvm: disabling virtualization on CPU1
>  > CPU 1 is now offline
>  > CPU1 is down
>  > kvm: disabling virtualization on CPU2
>  > CPU 2 is now offline
>  > ================> hang here.
>  >
>  > but x86.git/mm could go through down all the cpus....
>  >
>  > interesting...
>
>  i suspect some kobject related race, and i have the feeling this all is
>  timing dependent.
>
>  Andrew started seeing reboot hangs roughly around the time when the
>  kobject changes went upstream. Given that x86.git had flux in that
>  timeframe too i couldnt be sure what caused them.

it seems only happen
1. first hang with cpufreq enabled.
2. reboot to kernel with cpufreq disable will have problem.

wonder if different cpu freq out sync and next kernel with reboot
doesn't have cpufreq so it ....
-- with warm reset doesn't do the right job to sync freq again.

Greg,

where is patch to fix cpufreq problem?

YH
