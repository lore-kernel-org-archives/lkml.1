Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbYHFKV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbYHFKV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYHFKVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:21:49 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50729 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYHFKVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:21:48 -0400
Date: Wed, 6 Aug 2008 11:21:46 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26 1/25] mdb: Merkey's Kernel Debugger
Message-ID: <20080806102146.GA26936@brain>
References: <51542.166.70.238.45.1217815801.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51542.166.70.238.45.1217815801.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 08:10:01PM -0600, jmerkey@wolfmountaingroup.com wrote:
> Netware Style Debugger for Linux written by Jeffrey Vernon Merkey

I note that all of these 25 patches have the same title, either they are
one change and would be in one patch, or more likely they are all
changing different bits of the kernel and as such could do with
meaningful titles.  For a start without that they could not be tested in
-mm as they will not load into Andrews patch tools.  Second reviewers
for the specific sub-systems or architectures touched may only look over
the patches that are relevant to them.  Without any clue in the title
they probabally won't bother.

> --- linux-2.6.26/arch/x86/kernel/reboot.c	2008-07-13 15:51:29.000000000 -0600
> +++ linux-2.6.26-mdb/arch/x86/kernel/reboot.c	2008-08-03
> 12:49:01.000000000 -0600
> @@ -425,7 +425,16 @@
>  	/* O.K Now that I'm on the appropriate processor,
>  	 * stop all of the others.
>  	 */
> +#ifdef CONFIG_MDB
> +        // do not stop the other processors if the debugger is active +  
>      {
> +           extern atomic_t inmdb;
> +           if (!atomic_read(&inmdb))
> +	      smp_send_stop();
> +        }

Now its hard to be 100% sure that this spacing is what you have in your
copy as a lot of these patches appear at first viewing to be space munged
and wrapped probabally by your mailer.  BUT, this appears to be using
non-standard indent levels.  You will have much much much less resistance
if you follow the recommendations in Documentation/CodingStyle.  Also
you may want to check the emails as they have arrived at the LKML and
see if they are the same as your original, your mail reader may be
dammaging them.

> +#else
>  	smp_send_stop();
> +#endif // CONFIG_MDB
>  #endif
> 
>  	lapic_shutdown();
> 
> By making a contribution to this project, I certify that the contribution
> was created in whole or in part by me and I have the right to submit it
> under the open source license indicated in the file
> 
> Jeffrey Vernon Merkey

This sounds very much like you are signing off your patch as per the
DCO.  If so then normally that would be done via a Signed-off-by: header
at the end of the leader, not down here.

	Signed-off-by: Jeffrey Vernon Merkey <jmerkey@wolfmountaingroup.com>

-apw
