Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbYJKSRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbYJKSRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 14:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762353AbYJKSR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 14:17:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:33063 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851AbYJKSR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 14:17:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=cn1rwXmiW6nlO1O+Aw/+7ePuZKmBzTQBVR5kqeyNcxpfD/Xwb7SH2GqO2/gGnFEhJg
         TG3mOIA9ZOqPj167lRvjprCVHqBzOiL+NZdEdx483TBhqDTP6kXX2YZT8qYZ8rYBCtWT
         yl3sE9SYTG7KNlnIKMK2rP6apvCitC2xX/GzA=
Date: Sat, 11 Oct 2008 21:17:29 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Tom Zanussi <zanussi@comcast.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
Message-ID: <20081011181728.GA5309@localhost>
References: <20080923212914.GB5237@localhost> <1223386477.28348.42.camel@penberg-laptop> <1223623191.8959.26.camel@penberg-laptop> <1223628687.8959.37.camel@penberg-laptop> <1223629803.8959.40.camel@penberg-laptop> <1223631723.8959.46.camel@penberg-laptop> <1223701131.7489.25.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223701131.7489.25.camel@charm-linux>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 11:58:51PM -0500, Tom Zanussi wrote:
> It worked for me, but I also had to apply the following patch to
> kmemtraced:
> 
> diff --git a/kmemtraced.c b/kmemtraced.c
> index 217478d..324ced9 100644
> --- a/kmemtraced.c
> +++ b/kmemtraced.c
> @@ -109,6 +109,8 @@ static void *reader_thread(void *data)
>  		if (retval < 0)
>  			panic("splice() (from) failed: %s\n",
>  			      strerror(errno));
> +		if (!retval)
> +			continue;
>  		retval = splice(pipe_fd[0], NULL, log_fd, NULL,
>  				128, SPLICE_F_MOVE);
>  		if (retval < 0)
> 
> Otherwise it would end up hanging kmemtraced in the second splice (pipe
> to log_fd) if the return from the first splice was 0 (i.e. there's no
> data available (and we can never know if there will ever be any
> more)).

Thanks, I'll apply it.

> I'm not sure why kmemtraced is only splicing 128 bytes at a time - it
> seems to defeat the purpose - or why it wouldn't be using poll to know
> when there's at least a whole sub-buffer to splice, but to each his own.
> Hopefully the kernel patch at least fixes the loop. 

Yeah, it was a misguided attempt to fix the strange behavior.

> Tom


	Cheers,
	Eduard

