Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZHFWv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZHFWv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 18:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZHFWv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 18:51:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53246 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZHFWv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 18:51:27 -0400
Date: Thu, 6 Aug 2009 18:51:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Greg KH <gregkh@suse.de>
cc: Roland Dreier <rdreier@cisco.com>, Matt Fleming <matt@console-pimps.org>,
       David Kiliani <mail@davidkiliani.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: drivers/staging/meilhaus build broken with ftrace
In-Reply-To: <alpine.DEB.2.00.0908061844300.2840@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0908061849260.2840@gandalf.stny.rr.com>
References: <ada4oskfwtp.fsf@cisco.com> <alpine.DEB.2.00.0908061745430.2840@gandalf.stny.rr.com> <20090806222906.GA14792@suse.de> <alpine.DEB.2.00.0908061844300.2840@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Aug 2009, Steven Rostedt wrote:
> Yes the module did something funky, but what broke recordmcount.pl was not 
> something that is not allowed. The code broke because a weak function was 
> the only function in a section. This patch keeps it from crashing.
> 
> Hmm, maybe I should make it warn, because a weak function by itself in a 
> section will not be traced.

Now the question is, is this a crucial enough change to push for 31, or 
should we leave this for 32?

This patch is small enough for 31, but to add a warning would require a 
little more code rework. I can queue this up for 31 and then have the 
warning ready for 32.

-- Steve
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index d29baa2..979da4b 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -393,7 +393,7 @@ while (<IN>) {
>  	    $read_function = 0;
>  	}
>  	# print out any recorded offsets
> -	update_funcs() if ($text_found);
> +	update_funcs() if (defined($ref_func));
>  
>  	# reset all markers and arrays
>  	$text_found = 0;
> @@ -441,7 +441,7 @@ while (<IN>) {
>  }
>  
>  # dump out anymore offsets that may have been found
> -update_funcs() if ($text_found);
> +update_funcs() if (defined($ref_func));
>  
>  # If we did not find any mcount callers, we are done (do nothing).
>  if (!$opened) {
> 
