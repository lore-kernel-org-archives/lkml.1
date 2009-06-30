Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZGAJCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZGAJCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZGAJCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:02:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58282 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbZGAJCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:02:09 -0400
Date: Tue, 30 Jun 2009 08:33:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Renninger <trenn@suse.de>
Cc: kernel@stable.org, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rjw@sisk.pl, hidave.darkstar@gmail.com,
       penberg@cs.helsinki.fi, kernel-testers@vger.kernel.org,
       davej@redhat.com, mathieu.desnoyers@polymtl.ca,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Remove unneeded dbs_mutexes from ondemand
	and conservative governors
Message-ID: <20090630063339.GF1351@ucw.cz>
References: <20090623193215.GA31374@elte.hu> <1245938485-12663-2-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245938485-12663-2-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-25 16:01:24, Thomas Renninger wrote:
> Comment from Venkatesh:
> ...
> This mutex is just serializing the changes to those variables. I could't
> think of any functionality issues of not having the lock as such.
> 
> -> rip it out.
> 
> CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Thomas Renninger <trenn@suse.de>

>  static struct dbs_tuners {
> @@ -236,10 +222,7 @@ static ssize_t store_sampling_down_factor(struct cpufreq_policy *unused,
>  	if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
>  		return -EINVAL;
>  
> -	mutex_lock(&dbs_mutex);
>  	dbs_tuners_ins.sampling_down_factor = input;
> -	mutex_unlock(&dbs_mutex);
> -

You'd need to make s_down_factor atomic_t for this to work....
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
