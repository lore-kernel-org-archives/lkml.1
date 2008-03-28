Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbYC1VK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbYC1VK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYC1VKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:10:46 -0400
Received: from ns.suse.de ([195.135.220.2]:33874 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbYC1VKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:10:45 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Dan Williams" <dan.j.williams@intel.com>
Date: Sat, 29 Mar 2008 08:10:37 +1100 (EST)
Message-ID: <39784.192.168.1.70.1206738637.squirrel@neil.brown.name>
In-Reply-To: <1206732819.29383.11.camel@dwillia2-linux.ch.intel.com>
References: <20080328164351.30557.patches@notabene>
    <1080328054528.30605@suse.de>
    <20080327232252.20764ac4.akpm@linux-foundation.org>
    <1206732819.29383.11.camel@dwillia2-linux.ch.intel.com>
Subject: Re: [PATCH] md: Subject: introduce get_priority_stripe() to 
     improve raid456 write performance
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, March 29, 2008 6:33 am, Dan Williams wrote:
>  raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t
> len)
>  {
>  	raid5_conf_t *conf = mddev_to_conf(mddev);
> -	char *end;
> -	int new;
> +	unsigned long new;
>  	if (len >= PAGE_SIZE)
>  		return -EINVAL;
>  	if (!conf)
>  		return -ENODEV;
>
> -	new = simple_strtoul(page, &end, 10);
> -	if (!*page || (*end && *end != '\n'))
> +	if (strict_strtoul(page, 10, &new))
>  		return -EINVAL;
> -	if (new > conf->max_nr_stripes || new < 0)
> +	if (new > conf->max_nr_stripes || (int) new < 0)

I had suggested that "new < 0" test when I saw that 'new' was an 'int'.
A better suggestion would have been to make 'new' 'unsigned'.
Now that you have done that, the "< 0" it pointless and
should go.
Otherwise
  Acked-By: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown

