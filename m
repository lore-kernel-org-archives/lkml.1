Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbYEWRxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbYEWRxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYEWRxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:53:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44611 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYEWRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:53:23 -0400
Date: Fri, 23 May 2008 19:53:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Push ioctl BKL down into the i2c code
Message-ID: <20080523195302.42846394@hyperion.delvare>
In-Reply-To: <48368466.5040600@s5r6.in-berlin.de>
References: <20080522222327.1af72794@core>
	<20080523093545.175c769c@hyperion.delvare>
	<48368466.5040600@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Fri, 23 May 2008 10:46:30 +0200, Stefan Richter wrote:
> Jean Delvare wrote:
> > Description of what the patch does and why it is needed, please. I
> > can't apply it without that. My first impression is a patch making the
> > code bigger and more complex with no obvious benefit ;)
> 
> I wasn't asked, but:
> 
> The patch description was factored out.  ;-)
> http://lkml.org/lkml/2008/5/22/333

Hardly fits as a proper description for the git commit... But thanks
for the pointer.

> AFAIU it's a preparation for
> 
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ ?? @@ struct file_operations {
>  	unsigned int (*poll) (struct file *, struct poll_table_struct *);
> -	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
> 
> Obvious benefits:
>   - No new .ioctl()s.

I fail to see how this is related to the locking change.

>   - Heads up for subsystem people:  "Did you know you are taking the BKL?
>     You probably don't need to, and you definitely don't want to."

Good one... I admit that I didn't know.

-- 
Jean Delvare
