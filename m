Return-Path: <linux-kernel-owner+w=401wt.eu-S933848AbXKOXiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbXKOXiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbXKOXiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:38:12 -0500
Received: from mx2.univ-lille1.fr ([193.49.225.20]:52388 "EHLO
	mx2.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbXKOXiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:38:12 -0500
Message-ID: <473CD838.8060300@lifl.fr>
Date: Fri, 16 Nov 2007 00:37:28 +0100
From: Eric Piel <Eric.Piel@lifl.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.6) Gecko/20071101 Mandriva/2.0.0.6-5mdv2008.1 (2008.1) Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: trenn@suse.de
CC: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, cpufreq <cpufreq@lists.linux.org.uk>
Subject: Re: Kernel panic at boot with ondemand governor as	default	(2.6.24-rc2)
References: <4737539F.2070401@lifl.fr>	 <1194859012.4590.595.camel@queen.suse.de>  <47385D05.20705@lifl.fr> <1194880989.5474.12.camel@queen.suse.de>
In-Reply-To: <1194880989.5474.12.camel@queen.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender DNS name whitelisted, not delayed by milter-greylist-2.0.2 (mx2.univ-lille1.fr [193.49.225.20]); Fri, 16 Nov 2007 00:37:42 +0100 (CET)
X-USTL-MailScanner-Information: Please contact the ISP for more information
X-USTL-MailScanner: Found to be clean
X-USTL-MailScanner-From: eric.piel@lifl.fr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007年11月12日 16:23, Thomas Renninger wrote/a écrit:
> On Mon, 2007-11-12 at 15:02 +0100, Eric Piel wrote:
:
>> Another way would be to 
>> reorganise the initialisation code so that workqueue is initialised 
>> before the cpufreq framework is started, do you think it's possible?
> Making all this work with low-level drivers built in would be perfect of
> course...
Hi, I've just checked and it seems a bit weird, at least not as I 
expected: the workqueue is already initialized _before_ cpufreq! At 
least, from what I read in init/main.c, in do_basic_setup(), first there 
is a call to init_workqueues(), then there is a call to do_initcalls() 
(which indirectly calls cpufreq_core_init()). So maybe workqueues need 
something more than being initialized to work? What could it be? (My 
kernel is compiled for monoprocessor,  I can't see what goes wrong in 
wq_per_cpu()).

See you,
Eric

