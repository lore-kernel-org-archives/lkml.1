Return-Path: <linux-kernel-owner+w=401wt.eu-S1763730AbXHXIc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763730AbXHXIc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXHXIcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:32:22 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2086 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbXHXIcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:32:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH 22/30] ivtv: kzalloc() returns void pointer, no need to cast
Date: Fri, 24 Aug 2007 10:32:14 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kevin Thayer <nufan_wfk@yahoo.com>, Chris Kennedy <c@groovy.org>,
       video4linux-list@redhat.com
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <6e3f66d353155af12b075c2e919066908a2ce44c.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <6e3f66d353155af12b075c2e919066908a2ce44c.1187912217.git.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241032.14601.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 02:20:04 Jesper Juhl wrote:
> Since kzalloc() returns a void pointer, we don't need to cast the
> return value in drivers/media/video/ivtv/ivtv-queue.c
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Jesper,

Thanks for the patch. I've applied it to my latest tree and will ask 
Mauro to pull from it. The latest source is a bit different and has in 
fact a third cast which I've also removed.

Thanks,

	Hans

> ---
>  drivers/media/video/ivtv/ivtv-queue.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/ivtv/ivtv-queue.c
> b/drivers/media/video/ivtv/ivtv-queue.c index a04f938..45825b8 100644
> --- a/drivers/media/video/ivtv/ivtv-queue.c
> +++ b/drivers/media/video/ivtv/ivtv-queue.c
> @@ -196,7 +196,7 @@ int ivtv_stream_alloc(struct ivtv_stream *s)
>  		s->name, s->buffers, s->buf_size, s->buffers * s->buf_size /
> 1024);
>
>  	if (ivtv_might_use_pio(s)) {
> -		s->PIOarray = (struct ivtv_SG_element *)kzalloc(SGsize,
> GFP_KERNEL); +		s->PIOarray = kzalloc(SGsize, GFP_KERNEL);
>  		if (s->PIOarray == NULL) {
>  			IVTV_ERR("Could not allocate PIOarray for %s stream\n", s->name);
>  			return -ENOMEM;
> @@ -204,7 +204,7 @@ int ivtv_stream_alloc(struct ivtv_stream *s)
>  	}
>
>  	/* Allocate DMA SG Arrays */
> -	s->SGarray = (struct ivtv_SG_element *)kzalloc(SGsize, GFP_KERNEL);
> +	s->SGarray = kzalloc(SGsize, GFP_KERNEL);
>  	if (s->SGarray == NULL) {
>  		IVTV_ERR("Could not allocate SGarray for %s stream\n", s->name);
>  		if (ivtv_might_use_pio(s)) {


