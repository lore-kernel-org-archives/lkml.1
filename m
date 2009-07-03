Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZGCKK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZGCKK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZGCKKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:10:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbZGCKKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:10:19 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/2] CPUFREQ: Remove unneeded dbs_mutexes from ondemand and conservative governors
Date: Fri, 3 Jul 2009 12:10:15 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.23-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: kernel@stable.org, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rjw@sisk.pl, hidave.darkstar@gmail.com,
       penberg@cs.helsinki.fi, kernel-testers@vger.kernel.org,
       davej@redhat.com, mathieu.desnoyers@polymtl.ca,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <20090623193215.GA31374@elte.hu> <1245938485-12663-2-git-send-email-trenn@suse.de> <20090630063339.GF1351@ucw.cz>
In-Reply-To: <20090630063339.GF1351@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031210.16828.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Tuesday 30 June 2009 08:33:39 Pavel Machek wrote:
> On Thu 2009-06-25 16:01:24, Thomas Renninger wrote:
> > Comment from Venkatesh:
> > ...
> > This mutex is just serializing the changes to those variables. I could't
> > think of any functionality issues of not having the lock as such.
> > 
> > -> rip it out.
> > 
> > CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> >  static struct dbs_tuners {
> > @@ -236,10 +222,7 @@ static ssize_t store_sampling_down_factor(struct cpufreq_policy *unused,
> >  	if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
> >  		return -EINVAL;
> >  
> > -	mutex_lock(&dbs_mutex);
> >  	dbs_tuners_ins.sampling_down_factor = input;
> > -	mutex_unlock(&dbs_mutex);
> > -
> 
> You'd need to make s_down_factor atomic_t for this to work....
Can you provide a userspace scenario (or tell which kind of event must
happen in between), that this would cause problems, please.

Thanks,

  Thomas
