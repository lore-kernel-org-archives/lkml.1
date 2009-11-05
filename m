Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZKERrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZKERrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbZKERrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:47:39 -0500
Received: from bu3sch.de ([62.75.166.246]:48094 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbZKERri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:47:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CVE-2009-2584
Date: Thu, 5 Nov 2009 18:47:33 +0100
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>,
       Michael Gilbert <michael.s.gilbert@gmail.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com> <alpine.LFD.2.01.0911050831330.31845@localhost.localdomain> <alpine.LFD.2.01.0911050923580.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911050923580.31845@localhost.localdomain>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051847.36103.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 November 2009 18:38:21 Linus Torvalds wrote:
> @@ -161,14 +161,15 @@ static int options_show(struct seq_file *s, void *p)
>  static ssize_t options_write(struct file *file, const char __user *userbuf,
>  			     size_t count, loff_t *data)
>  {
> -	unsigned long val;
> -	char buf[80];
> +	char buf[16];
>  
> -	if (strncpy_from_user(buf, userbuf, sizeof(buf) - 1) < 0)
> +	if (count >= sizeof(buf))
> +		return -EINVAL;
> +	if (copy_from_user(buf, userbuf, count))
>  		return -EFAULT;
> -	buf[count - 1] = '\0';
> -	if (!strict_strtoul(buf, 10, &val))
> -		gru_options = val;
> +	buf[count] = '\0';
> +	if (strict_strtoul(buf, 0, &gru_options))
> +		return -EINVAL;
>  
>  	return count;
>  }
> 
> 

Looks OK to me. I can't test it however, as I don't own the hardware.

-- 
Greetings, Michael.
