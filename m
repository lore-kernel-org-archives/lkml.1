Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYEaARq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYEaARq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYEaARe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:17:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:10413 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbYEaARd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=vmD6W6e1G9o14aBdvdZKSpg1K9lb73bu7G2NV7T29XFORbaMK74d1aetXaHuFUO+uIAM0k9XvLqBBYhcXlFT3f/5bWjE4/GPOb9korkDKi3umw6B9LGFoEQ4n5TZameC4ejUsWPhNXDRQTApZycZ1S3G89M74MZE2FLuXEdqXEc=
Date: Sat, 31 May 2008 04:12:42 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: casey@schaufler-ca.com, paul.moore@hp.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH BUGFIX -v2 -rc4] Smack: Respect 'unlabeled' netlabel
	mode
Message-ID: <20080531011242.GA7061@ubuntu>
References: <20080530233603.GA2994@ubuntu> <20080530235751.GA6888@ubuntu> <20080530162500.1411f14d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530162500.1411f14d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 04:25:00PM -0700, Andrew Morton wrote:
> On Sat, 31 May 2008 02:57:51 +0300
> "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:
> 
> > +		mutex_lock(&smack_ambient_lock);
> > +		nlsp->domain = kstrdup(smack_net_ambient, GFP_ATOMIC);
> > +		mutex_unlock(&smack_ambient_lock);
> 
> no no no no no.  And no.
> 
> GFP_ATOMIC is *unreliable*.  Using it in a "security" feature is a bug
> - if it fails, the feature isn't secure any more.
> 
> Failing to check the kmalloc() return value might be a bug.
> 
> If we _need_ GFP_ATOMIC here then taking a mutex in a cannot-sleep
> context is a bug.
> 
> The patch adds a kmalloc but doesn't add a kfree.  Is it leaky?
> 
> Finally, why is there a need to take a lock around a single store
> instruction?

Possibly the worst three lines written ever. GFP_ATOMIC line
was cut-and-paste forgetting to change it to GFP_KERNEL and the lock
is already useless. 

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

