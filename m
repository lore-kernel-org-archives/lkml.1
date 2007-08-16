Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbXHPURI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbXHPURI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXHPUQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:16:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbXHPUQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:16:54 -0400
Date: Thu, 16 Aug 2007 16:16:49 -0400
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: khvcd
Message-ID: <20070816201649.GA5375@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,
 In profiling bootup time, we noticed something new appeared
on the graph at http://pjones.fedorapeople.org/bootchart-preinit.png
in the name of khvcd.

"wtf is this" was my first reaction.
Followed shortly by much headscratching after finding it's
created by drivers/char/hvc_console.c whose Kconfig yeilds..

config HVC_DRIVER
        bool
        help
          Users of pSeries machines that want to utilize the hvc console front-end
          module for their backend console driver should select this option.

Which is a little confusing for those of us not actually using a pSeries.
The above profile came from a x86 box.
A little more grepping around revealed that lguest select's HVC_DRIVER,
thus sneaking this config option into the build.

asides from the needed Kconfig clarification, is it necessary for khvcd
to run at all if the lguest module hasn't been loaded ?  Is it possible
we can somehow delay creation of the kthread ?

	Dave

-- 
http://www.codemonkey.org.uk
