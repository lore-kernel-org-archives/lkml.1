Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0BOOEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 09:04:50 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:50859 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0BOOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 09:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=tg4KC8jA2n0VTML4GwsXdx+EEwzTkJ3/26/Wz0PWPOToALJnpAdeTzLN0eVJa/02It
         oBoD423cGC5ci5DlwLT3GytE38n2TlXVWHqfakgpEoYKK9o9wVIFTR7R1MJVLBw/R3BF
         X2XXmxYZiDrL9JwglYNjV2LyXAF0IK5f2lZ2I=
Date: Mon, 15 Feb 2010 17:04:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bug list: range checking issues
Message-ID: <20100215140435.GL14210@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100215124046.GB18821@bicker> <20100215134724.GA4107@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215134724.GA4107@x200>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 03:47:24PM +0200, Alexey Dobriyan wrote:
> On Mon, Feb 15, 2010 at 03:40:56PM +0300, Dan Carpenter wrote:
> > kernel/pid_namespace.c +96 create_pid_namespace(26) warn: buffer overflow 'ns->pidmap' 1 <= 1
> 
> What overflows exactly here?

It's a false positive:

smatch thinks the array ns->pidmap[] has ARRAY_SIZE() of 1 and i is 1.

kernel/pid_namespace.c
    95          for (i = 1; i < PIDMAP_ENTRIES; i++)
    96                  atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);

On my .config PIDMAP_ENTRIES is 0 so that line is never reached.

regards,
dan carpenter
