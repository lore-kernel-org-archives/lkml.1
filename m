Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbXEQAiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbXEQAiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbXEQAiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:38:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbXEQAiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:38:06 -0400
Date: Wed, 16 May 2007 20:37:33 -0400
From: Dave Jones <davej@redhat.com>
To: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
Cc: Daniel Drake <dsd@gentoo.org>, duaneg@dghda.com, prakash@punnoor.de,
       linux-kernel@vger.kernel.org, Ed Sweetman <safemode2@comcast.net>,
       mark.langsdorf@amd.com
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
Message-ID: <20070517003733.GD16810@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>,
	Daniel Drake <dsd@gentoo.org>, duaneg@dghda.com, prakash@punnoor.de,
	linux-kernel@vger.kernel.org, Ed Sweetman <safemode2@comcast.net>,
	mark.langsdorf@amd.com
References: <20070516235050.9B4237B409F@zog.reactivated.net> <20070517002614.GU15763@ifa.hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517002614.GU15763@ifa.hawaii.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 02:26:14PM -1000, Joshua Hoblitt wrote:
 > I don't think this is quiet right either as Ed Sweetman has reported
 > that this issue doesn't occur on single socket/multi-core systems.

I'm not sure why [*], because this should be preventing it..

                if (num_online_cpus() != 1) {
                        printk(KERN_ERR PFX "MP systems not supported by PSB BIOS structure\n");
                        kfree(data);
                        return -ENODEV;
                }

num_online_cpus will return 2 in a dual-core system, even though there's
just one socket.  Given they share a power plane, if there's a valid
PSB structure however, it may be usable.  Though this isn't necessarily
true for all future dual-core AMD CPUs, and the ACPI tables really
should be preferred.

	Dave

[*] unless you have the second core disabled or CONFIG_SMP=n

-- 
http://www.codemonkey.org.uk
